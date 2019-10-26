//
//  Wrapper.swift
//  Brogue
//
//  Created by Raymund Vidar on 10/16/19.
//  Copyright © 2019 darthvid. All rights reserved.
//

//import Foundation
// Darth: Needed for DispatchQueue
import AppKit

struct WrapperGlobals {
    static var wrapper: Wrapper? = nil
}



class Wrapper {
    let dqInputEvents = DispatchQueue(label: "InputEvents", qos: .background)
    //let glyphMgr = GlyphMgr()
    
    var isAppActive: Bool = false
    var currEvent: NSEvent? = nil
    
    init() {
        // Darth: Register C callbacks.
        callbacks.isEventWhilePaused = wrapIsEventWhilePaused
        callbacks.isAppActive = wrapIsAppActive
        callbacks.getBrogueEvent = wrapGetBrogueEvent
        callbacks.isControlKeyDown = wrapIsControlKeyDown
        callbacks.plotChar = wrapPlotChar
    }
    
    
    func setInputEvent(_ event: NSEvent) {
        //print("\(#function)")
        
        dqInputEvents.async(execute: {
            //print(event.charactersIgnoringModifiers!)
            self.currEvent = event
        })
    }
    
    func isInputEventExist() -> Bool {
        var res: Bool = false
        dqInputEvents.sync(execute: {
            res =  (nil != self.currEvent)
        })
        return res
    }
    
    func getInputEvent() -> rogueEvent {
        var evt = NSEvent()
        var ret = rogueEvent(eventType: NUMBER_OF_EVENT_TYPES, param1: 0, param2: 0, controlKey: 0, shiftKey: 0)
        
        //print("\(#function)")
        
        // Darth: Copy the event then reset. Maybe I should just have a permanent variable and just change the event status to something non-existent? Think about that for the future.
        
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
    
    func runGameLoop() {
        // Darth: Run the game loop in a separate thread (background QoS) via DispatchQueue.
        
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "BrogueGameLoop", qos: .background)
        group.enter()
        dispatchQueue.async(group: group,  execute: {
            // Darth: Run Brogue's rogueMain()
            rogueMain()
            group.leave()
        })
        

        // does not wait. But the code in notify() gets after enter() and leave() calls are balanced
        group.notify(queue: .main) {
            print("\(#function): runGame() has finished!")
            self.evtBrogueEnded()
        }
    }
    
    func evtBrogueEnded() {
        // trigger the app to close
        print("\(#function)")
        exit(0)
    }
    
    func plotChar(_ ch: PlotCharStruct) {
        //print("\(#function)", ch.inputChar)
    }
}

/*
 ******* [The callbacks called by wrapper.c. Not part of class but bridges to it.] *******
 */

func wrapGetBrogueEvent(textInput: Int8, colorsDance: Int8) -> rogueEvent {
    let evt = rogueEvent(eventType: NUMBER_OF_EVENT_TYPES, param1: 0, param2: 0, controlKey: 0, shiftKey: 0)
    
    //print("\(#function),", textInput, colorsDance)
    return (WrapperGlobals.wrapper?.getInputEvent() ?? evt)
}


func wrapIsEventWhilePaused(milliseconds: Int32) -> Int8 {
    // Returns true if the player interrupted the wait with a keystroke or mouse action; otherwise false.
    
    var res: Int8 = 0
    
    //print("\(#function),", milliseconds)
    //print("\(#function),", milliseconds, WrapperGlobals.wrapper!.isAppActive)
    if (WrapperGlobals.wrapper!.isAppActive) {
        // Darth: Use DQ to check. Return "true" if there is an event available.
        if (WrapperGlobals.wrapper!.isInputEventExist()) {
            res = Int8(truncating: NSNumber(true))
        }
        else {
            // Darth: Should we actually implement some sort of sleep here? ¯\_(ツ)_/¯
            //          How to provide that delay without killing the thread?
            //sleep(UInt32(milliseconds))
            //print("fake sleep,", milliseconds, WrapperGlobals.wrapper!.isAppActive)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                // your code here
            }
        }
    }
    
    return res
}

func wrapIsAppActive() -> Int8 {
    //print("\(#function)", WrapperGlobals.wrapper!.isAppActive)
    return Int8(truncating: NSNumber(value:WrapperGlobals.wrapper!.isAppActive))
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
}

func wrapPlotChar(ch: PlotCharStruct) {
    //print("\(#function)", ch.inputChar)
    WrapperGlobals.wrapper?.plotChar(ch)
}
