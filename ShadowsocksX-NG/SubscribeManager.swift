//
//  SubscribeManager.swift
//  ShadowsocksX-NG
//
//  Created by 秦宇航 on 2017/6/19.
//  Copyright © 2017年 qiuyuzhou. All rights reserved.
//

import Foundation

class SubscribeManager:NSObject{
    static let instance:SubscribeManager = SubscribeManager()
    
    var subscribes:[Subscribe]
    var subscribesDefault : [[String: AnyObject]]
    let defaults = UserDefaults.standard
    
    var autoUpdateSubscribesTimer:Timer?
    let repeatTimeinterval: TimeInterval = 3600.0
    
    fileprivate override init() {
        subscribes = []
        subscribesDefault = [[:]]
        if let subscribesDefault = defaults.array(forKey: "Subscribes") {
            for value in subscribesDefault{
                subscribes.append(Subscribe.fromDictionary(value as! [String : AnyObject]))
            }
        }
    }
    func addSubscribe(oneSubscribe: Subscribe) -> Bool {
        for (index, value) in subscribes.enumerated() {
            if Subscribe.isSame(source: oneSubscribe, target: value) {
                return true
            }
            if value.isExist(oneSubscribe) {
                subscribes.replaceSubrange((index..<index + 1), with: [oneSubscribe])
                return true
            }
        }
        subscribes.append(oneSubscribe)
        return true
    }
    func deleteSubscribe(atIndex: Int) -> Bool {
        subscribes[atIndex].updateServerFromFeed(delete: true)
        subscribes.remove(at: atIndex)
        return true
    }
    func reload() {
        subscribes.removeAll()
        
        if let subscribesDefault = defaults.array(forKey: "Subscribes") {
            for value in subscribesDefault{
                subscribes.append(Subscribe.fromDictionary(value as! [String : AnyObject]))
            }
        }
    }
    func save() {
        defaults.set(subscribesToDefaults(data: subscribes), forKey: "Subscribes")
        defaults.synchronize()
    }
    fileprivate func subscribesToDefaults(data: [Subscribe]) -> [[String: AnyObject]]{
        var ret : [[String: AnyObject]] = []
        for value in data {
            ret.append(Subscribe.toDictionary(value))
        }
        return ret
    }
    fileprivate func DefaultsToSubscribes(data:[[String: AnyObject]]) -> [Subscribe] {
        var ret : [Subscribe] = []
        for value in data{
            ret.append(Subscribe.fromDictionary(value))
        }
        return ret
    }
    func updateAllServerFromSubscribe(auto: Bool, inform: Bool=true, ping: Bool=true){
        let dispatch = DispatchGroup()
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        subscribes.forEach { s in
            if (s.isActive && (!auto || s.getAutoUpdateEnable())){
                dispatch.enter()
                queue.async {
                    s.updateServerFromFeed(inform: inform)
                    dispatch.leave()
                }
            }
        }
        
        //每次更新订阅后自动测试延时
        if ping {
            dispatch.notify(queue: DispatchQueue.main) {
                ConnectTestigManager.start()
            }
        }
    }
    
    func timingUpdateSubscribes() {
        var enable = false
        for i in 0..<subscribes.count {
            if subscribes[i].isActive && subscribes[i].getAutoUpdateEnable() {
                enable = true
                break
            }
        }
        if enable && autoUpdateSubscribesTimer == nil {
            autoUpdateSubscribesTimer = Timer.scheduledTimer(withTimeInterval: repeatTimeinterval, repeats: true) { timer in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.updateAllServerFromSubscribe(auto: true, inform: false, ping: false)
                }
            }
        } else if !enable {
            autoUpdateSubscribesTimer?.invalidate()
        }
    }
}
