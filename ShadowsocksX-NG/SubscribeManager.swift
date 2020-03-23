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
    func updateAllServerFromSubscribe(auto: Bool){
        let dispatch = DispatchGroup()
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
        subscribes.forEach { s in
            if (!auto || s.getAutoUpdateEnable()){
                dispatch.enter()
                queue.async {
                    s.updateServerFromFeed()
                    dispatch.leave()
                }
            }
        }
        
        //每次更新订阅后自动测试延时
        dispatch.notify(queue: DispatchQueue.main) {
            PingServers.instance.ping()
        }
    }
}
