//
//  Wrapper.swift
//  Brogue
//
//  Created by Raymund Vidar on 10/16/19.
//  Copyright © 2019 darthvid. All rights reserved.
//

//import Foundation
import AppKit

struct WrapperGlobals {
    static var scene: GameScene? = nil
    static var wrapper: Wrapper? = nil
}



class Wrapper: NSObject {
    var isAppActive: Bool = false
    var currEvent: NSEvent? = nil
    
    override init() {
        // Darth: Register C callbacks. 
        callbacks.cbVoidVoid = wrapperVoidVoid
        callbacks.isEventWhilePaused = wrapIsEventWhilePaused
        callbacks.isAppActive = wrapIsAppActive
        callbacks.getBrogueEvent = wrapGetBrogueEvent
        //setWrapperCallbacks(callbacks)
        //setAdapterCallbacks(wrapperVoidVoid)
    }
    
    func hajime() {
        NotificationCenter.default.addObserver(self, selector: #selector(setAppActive), name: NSNotification.Name(rawValue: "AppActive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setAppInactive), name: NSNotification.Name(rawValue: "AppInactive"), object: nil)
    }
    
    func wrapVoidVoid() {
        //print("\(#function)")
    }
    
    func setInputEvent(_ event: NSEvent) {
        //print("\(#function)")
        print(event.charactersIgnoringModifiers!)
    }
    
    // Darth: So I reaaally have to make these Objective-C? :(

    @objc func setAppActive() {
        //print("\(#function)")
        isAppActive = true
    }

    @objc func setAppInactive() {
        //print("\(#function)")
        isAppActive = false
    }

}


// ********* [not part of class] ***************************

func wrapGetBrogueEvent(textInput: Int8, colorsDance: Int8) -> rogueEvent {
    var evt = rogueEvent(eventType: eventTypes(rawValue: 0), param1: 0, param2: 0, controlKey: 0, shiftKey: 0)
    
    print("\(#function),", textInput, colorsDance)
    
    //evt.eventType = eventTypes(rawValue: 0)
    
    WrapperGlobals.wrapper?.currEvent = nil
    
    return evt
}


func wrapIsEventWhilePaused(milliseconds: Int32) -> Int8 {
    // Returns true if the player interrupted the wait with a keystroke or mouse action; otherwise false.
    
    var res: Int8 = 0
    
    //print("\(#function),", milliseconds)
    //print("\(#function),", milliseconds, WrapperGlobals.wrapper!.isAppActive)
    if (WrapperGlobals.wrapper!.isAppActive) {
        if (nil != WrapperGlobals.wrapper?.currEvent) {
            res = Int8(truncating: NSNumber(true))
        }
    }
    
    return res
}

func wrapIsAppActive() -> Int8 {
    //print("\(#function)", WrapperGlobals.wrapper!.isAppActive)
    return Int8(truncating: NSNumber(value:WrapperGlobals.wrapper!.isAppActive))
}


func wrapperVoidVoid() {
    //print("\(#function)")
}
