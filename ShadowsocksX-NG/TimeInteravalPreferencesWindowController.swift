//
//  TimeInteravalPreferencesWindowController.swift
//  ShadowsocksX-NG

import Cocoa

class TimeInteravalPreferencesWindowController: NSWindowController, NSWindowDelegate {
    var delayTestEnable: Bool!
    var subscribeUpdateEnable: Bool!
    var delayTestInteraval:Int!
    var subscribeUpdatetInteraval:Int!
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        delayTestEnable = UserDefaults.standard.bool(forKey: "TimeInteraval.DelayTestEnable")
        subscribeUpdateEnable = UserDefaults.standard.bool(forKey: "TimeInteraval.SubscribeUpdateEnable")
        delayTestInteraval = UserDefaults.standard.integer(forKey: "TimeInteraval.DelayTestTime")
        subscribeUpdatetInteraval = UserDefaults.standard.integer(forKey: "TimeInteraval.SubscribeUpdateTime")
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.delegate = self
    }
    
    //------------------------------------------------------------
    // NSWindowDelegate
    func windowWillClose(_ notification: Notification) {
        if delayTestEnable != UserDefaults.standard.bool(forKey: "TimeInteraval.DelayTestEnable")
            || delayTestInteraval != UserDefaults.standard.integer(forKey: "TimeInteraval.DelayTestTime") {
            NotificationCenter.default.post(name: NOTIFY_TIME_INTERAVAL_DELAY_CHANGED, object: nil)
        }
        if subscribeUpdateEnable != UserDefaults.standard.bool(forKey: "TimeInteraval.SubscribeUpdateEnable")
            || subscribeUpdatetInteraval != UserDefaults.standard.integer(forKey: "TimeInteraval.SubscribeUpdateTime") {
            NotificationCenter.default.post(name: NOTIFY_TIME_INTERAVAL_SUBSCRIBE_CHANGED, object: nil)
        }
    }
}
