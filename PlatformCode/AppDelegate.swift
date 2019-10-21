//
//  AppDelegate.swift
//  Brogue
//
//  Created by Raymund Vidar on 10/11/19.
//  Copyright © 2019 darthvid. All rights reserved.
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    // Darth: For new AppActive detection.
    
    func applicationDidBecomeActive(_ aNotification: Notification) {
        // Sent by the default notification center immediately after the application becomes active.
        
        // Darth: Maybe no need to protect from concurrency?
        WrapperGlobals.wrapper?.isAppActive = true
    }
    
    func applicationWillResignActive(_ aNotification: Notification) {
        // Sent by the default notification center immediately before the application is deactivated.
        
        // Darth: Maybe no need to protect from concurrency?
        WrapperGlobals.wrapper?.isAppActive = false
    }
}
