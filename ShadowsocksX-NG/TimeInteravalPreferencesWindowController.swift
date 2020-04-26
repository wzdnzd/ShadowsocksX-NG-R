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
        
        delayTestEnable = UserDefaults.standard.bool(forKey: USERDEFAULTS_TIME_INTERAVAL_DALAY_TEST_ENABLE)
        subscribeUpdateEnable = UserDefaults.standard.bool(forKey: USERDEFAULTS_TIME_INTERAVAL_SUBSCRIBE_UPDATE_ENABLE)
        delayTestInteraval = UserDefaults.standard.integer(forKey: USERDEFAULTS_TIME_INTERAVAL_DALAY_TEST_TIME)
        subscribeUpdatetInteraval = UserDefaults.standard.integer(forKey: USERDEFAULTS_TIME_INTERAVAL_SUBSCRIBE_UPDATE_TIME)
        
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        self.window?.delegate = self
    }
    
    //------------------------------------------------------------
    // NSWindowDelegate
    func windowWillClose(_ notification: Notification) {
        if delayTestEnable != UserDefaults.standard.bool(forKey: USERDEFAULTS_TIME_INTERAVAL_DALAY_TEST_ENABLE)
            || delayTestInteraval != UserDefaults.standard.integer(forKey: USERDEFAULTS_TIME_INTERAVAL_DALAY_TEST_TIME) {
            NotificationCenter.default.post(name: NOTIFY_TIME_INTERAVAL_DELAY_CHANGED, object: nil)
        }
        if subscribeUpdateEnable != UserDefaults.standard.bool(forKey: USERDEFAULTS_TIME_INTERAVAL_SUBSCRIBE_UPDATE_ENABLE)
            || subscribeUpdatetInteraval != UserDefaults.standard.integer(forKey: USERDEFAULTS_TIME_INTERAVAL_SUBSCRIBE_UPDATE_TIME) {
            NotificationCenter.default.post(name: NOTIFY_TIME_INTERAVAL_SUBSCRIBE_CHANGED, object: nil)
        }
    }
}
