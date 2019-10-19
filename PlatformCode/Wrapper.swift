//
//  Wrapper.swift
//  Brogue
//
//  Created by Raymund Vidar on 10/16/19.
//  Copyright © 2019 darthvid. All rights reserved.
//

//import Foundation
// Darth: Needed for NotificationCenter
import AppKit

struct WrapperGlobals {
    static var scene: GameScene? = nil
    static var wrapper: Wrapper? = nil
}



class Wrapper: NSObject {
    let dqInputEvents = DispatchQueue(label: "InputEvents", qos: .background)
    
    var isAppActive: Bool = false
    var currEvent: NSEvent? = nil
    
    override init() {
        // Darth: Register C callbacks. 
        callbacks.cbVoidVoid = wrapperVoidVoid
        callbacks.isEventWhilePaused = wrapIsEventWhilePaused
        callbacks.isAppActive = wrapIsAppActive
        callbacks.getBrogueEvent = wrapGetBrogueEvent
        callbacks.isControlKeyDown = wrapIsControlKeyDown
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
        
        dqInputEvents.async(execute: {
            //print(event.charactersIgnoringModifiers!)
            self.currEvent = event
        })
    }
    
    func getInputEvent() -> rogueEvent {
        var evt = NSEvent()
        var ret = rogueEvent(eventType: NUMBER_OF_EVENT_TYPES, param1: 0, param2: 0, controlKey: 0, shiftKey: 0)
        
        //print("\(#function)")
        //print(event.charactersIgnoringModifiers!)
        dqInputEvents.sync(execute: {
            if (nil != self.currEvent) {
                evt = self.currEvent!
                self.currEvent = nil
            }
            
        })
        
        if (NSEvent.EventType.keyDown == evt.type) {
            print("\(#function) \(evt.charactersIgnoringModifiers!)")
            
            ret.eventType = KEYSTROKE
            let s = evt.charactersIgnoringModifiers!.unicodeScalars
            ret.param1 = Int(s[s.startIndex].value)
            ret.controlKey = evt.modifierFlags.contains(.control) ? 1 : 0
            ret.shiftKey = evt.modifierFlags.contains(.shift) ? 1 : 0
        }
        
        return ret
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
    let evt = rogueEvent(eventType: NUMBER_OF_EVENT_TYPES, param1: 0, param2: 0, controlKey: 0, shiftKey: 0)
    
    //print("\(#function),", textInput, colorsDance)
    
    //WrapperGlobals.wrapper?.getInputEvent()
    
    //WrapperGlobals.wrapper?.currEvent = nil
    
    return (WrapperGlobals.wrapper?.getInputEvent() ?? evt)
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

func wrapIsControlKeyDown() -> Int8 {
    // Darth: There's another solution assuming one needs to track this all throughout, but this is only needed in the main menu, so perhaps it's worth keeping the current polling solution.
    
    var res = Int8(0)
    DispatchQueue.main.async {
        //Do UI Code here.
        res = ((NSApp.currentEvent!.modifierFlags.contains(.control)) ? 1 : 0)
    }
    if (0 != res) {
        print("\(#function)", res)
    }
    
    return res
    //return 0
}
