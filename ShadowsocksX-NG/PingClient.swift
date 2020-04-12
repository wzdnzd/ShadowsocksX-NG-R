//
//  PingClient.swift
//  ShadowsocksX-R
//
//  Created by 称一称 on 16/9/5.
//  Copyright © 2016年 qiuyuzhou. All rights reserved.
//


import Foundation

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

public typealias SimplePingClientCallback = (String?)->()

var isTesting:Bool = false
var neverSpeedTestBefore:Bool = true

class PingServers:NSObject{
    static let instance = PingServers()
    
    func runCommand(cmd : String, args : String...) -> (output: [String], error: [String], exitCode: Int32) {
        
        var output : [String] = []
        var error : [String] = []
        
        let task = Process()
        task.launchPath = cmd
        task.arguments = args
        
        let outpipe = Pipe()
        task.standardOutput = outpipe
        let errpipe = Pipe()
        task.standardError = errpipe
        
        task.launch()
        
        let outdata = outpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: outdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            output = string.components(separatedBy: "\n")
        }
        
        let errdata = errpipe.fileHandleForReading.readDataToEndOfFile()
        if var string = String(data: errdata, encoding: .utf8) {
            string = string.trimmingCharacters(in: .newlines)
            error = string.components(separatedBy: "\n")
        }
        
        task.waitUntilExit()
        let status = task.terminationStatus
        
        return (output, error, status)
    }
    
    func getlatencyFromString(result:String) -> Double?{
        var res = result
        if !result.contains("round-trip min/avg/max/stddev =") {
            return nil
        }
        res.removeSubrange(res.range(of: "round-trip min/avg/max/stddev = ")!)
        res = String(res.dropLast(3))
        res = res.components(separatedBy: "/")[1]
        let latency = Double(res)
        return latency
    }
    
    // TODO
    func ping(inform: Bool=true) {
        let SerMgr = ServerProfileManager.instance
        if SerMgr.profiles.count <= 0 {
            return
        }
        
        neverSpeedTestBefore = false
        
        let group = DispatchGroup()
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        
        for i in 0..<SerMgr.profiles.count {
            group.enter()
            queue.async {
                if let outputString = self.runCommand(cmd: "/sbin/ping", args: "-c","5","-t","2",SerMgr.profiles[i].serverHost).output.last {
                    if let latency = self.getlatencyFromString(result: outputString) {
                        SerMgr.profiles[i].latency = String(latency)
                    }
                }
                group.leave()
            }
        }
        group.notify(queue: DispatchQueue.main) {
            var fastestId = 0
            var fastestSpeed = Double.infinity
            
            for k in 0..<SerMgr.profiles.count {
                if let late = SerMgr.profiles[k].latency{
                    if let latency = Double(late), latency < fastestSpeed {
                        fastestSpeed = latency
                        fastestId = k
                    }
                }
            }
            ConnectTestigManager.sync(SerMgr: SerMgr, fastestId: fastestId, fastestSpeed: fastestSpeed, title: "ICMP测试完成！最快", inform: inform)
        }
    }
}

class ConnectTestigManager {
    static func start(inform: Bool=true) {
        if !isTesting {
            isTesting = true
            
            if UserDefaults.standard.bool(forKey: "TCP") {
                Tcping.instance.ping(inform: inform)
            } else {
                PingServers.instance.ping(inform: inform)
            }
        }
    }
    
    static func sync(SerMgr: ServerProfileManager, fastestId:Int, fastestSpeed:Double, title: String, inform: Bool) {
        if fastestId < 0 || fastestSpeed == Double.infinity || SerMgr.profiles.count <= fastestId {
            return
        }
        
        if fastestId < ServerProfileManager.instance.profiles.count {
            let fastestProfile = SerMgr.profiles[fastestId]
            if fastestProfile.isSame(profile: ServerProfileManager.instance.profiles[fastestId])
                && !fastestProfile.isSame(profile: ServerProfileManager.instance.getActiveProfile() ?? fastestProfile) {
                ServerProfileManager.instance.setActiveProfiledId(fastestProfile.uuid)
                if writeSSLocalConfFile(fastestProfile.toJsonConfig()) {
                    ReloadConfSSLocal()
                }
            }
        }
        
        if inform {
            let notice = NSUserNotification()
            notice.title = "\(title)\(SerMgr.profiles[fastestId].latency!)ms"
            notice.subtitle = "最快的是\(SerMgr.profiles[fastestId].serverHost) \(SerMgr.profiles[fastestId].remark)"
            
            NSUserNotificationCenter.default.deliver(notice)
        }
        
        UserDefaults.standard.setValue("\(SerMgr.profiles[fastestId].latency!)", forKey: "FastestNode")
        UserDefaults.standard.synchronize()
        
        DispatchQueue.main.async {
            isTesting = false
            (NSApplication.shared.delegate as! AppDelegate).updateServersMenu()
            (NSApplication.shared.delegate as! AppDelegate).updateRunningModeMenu()
        }
    }
}
