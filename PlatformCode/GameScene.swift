//
//  GameScene.swift
//  Brogue
//
//  Created by Raymund Vidar on 10/11/19.
//  Copyright © 2019 darthvid. All rights reserved.
//

import SpriteKit
import GameplayKit



 struct GameSceneVars {
    static weak var scene = GameScene()
}
// To see Swift classes from ObjC they MUST be prefaced with @objc and be public/open
@objc public class GameScene: SKScene {
//class GameScene: SKScene {
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let dqInputEvents = DispatchQueue(label: "InputEvents", qos: .background)
    @objc public var aEvent: NSEvent? = nil
    
    override public func didMove(to view: SKView) {
        // Darth: View is up?
        print("\(#function)")
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AppActive"), object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(setAppActive), name: NSNotification.Name(rawValue: "AppActive"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(setAppInactive), name: NSNotification.Name(rawValue: "AppInactive"), object: nil)
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
        
        //runGame()
        GameSceneVars.scene = self
        setScene(self)
        setAdapterCallbacks(setGameCell)
        dispatchBrogueGameLoop()
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override public func mouseDown(with event: NSEvent) {
        self.touchDown(atPoint: event.location(in: self))
    }
    
    override public func mouseDragged(with event: NSEvent) {
        self.touchMoved(toPoint: event.location(in: self))
    }
    
    override public func mouseUp(with event: NSEvent) {
        self.touchUp(atPoint: event.location(in: self))
    }
    
    override public func keyDown(with event: NSEvent) {
        switch event.keyCode {
        case 0x31:
            if let label = self.label {
                label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
            }
        default:
            print("foo: \(foo(27)) keyDown: \(event.characters!) keyCode: \(event.keyCode)")
            controlKeyIsDown()
        }
        print(event.charactersIgnoringModifiers!)
        dqInputEvents.async(execute: {
            self.aEvent = event
        })
        
        
        //var charToPlot:PlotCharStruct
    }
    
    
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    override public func sceneDidLoad() {
        // Darth: Scene is loaded, but view is not yet up?
        print("\(#function)")
    }
    
    func dispatchBrogueGameLoop() {
        // Darth: Run the game loop (via wrapper) in a separate thread.
        
        let group = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "QueueIdentification", qos: .background)
        group.enter()
        dispatchQueue.async(group: group,  execute: {
            //Time consuming task here
            runGame()
            group.leave()
        })
        

        // does not wait. But the code in notify() gets after enter() and leave() calls are balanced
        group.notify(queue: .main) {
            print("\(#function): runGame() has finished!")
        }
    }

    
    /*@objc public func setCell(inputChar: UInt32,
                              xLoc: Int, yLoc: Int,
                              backRed: Int, backGreen: Int, backBlue: Int,
                              foreRed: Int, foreGreen: Int, foreBlue: Int) {
    */
    //@objc public func setCell(inputChar: UInt32) {
    @objc public func setCell(charToPlot: PlotCharStruct) {
        //print("\(#function)")
        //print("setcell(", charToPlot.inputChar, charToPlot.xLoc, charToPlot.yLoc, ")")
        
    }
    
    @objc public func bridgeCurrInputEvent(returnEvent: UnsafeMutablePointer<rogueEvent>, textInput:Bool, colorsDance: Bool) {
        print("\(#function)", textInput, colorsDance)
        
        var currEvent: NSEvent?
        
        dqInputEvents.sync(execute: {
            currEvent = self.aEvent!
            self.aEvent = nil
        })
        
        //NSEventType theEventType = theEvent.type;
        if (NSEvent.EventType.keyDown == currEvent?.type) {
            print("char", (currEvent?.charactersIgnoringModifiers!)!.first);
        }
        
        if (colorsDance) {
            //shuffleTerrainColors(3, true)
            shuffleTerrainColors(3, 1)
            commitDraws()
        }
        
        returnEvent.pointee.eventType = eventTypes(rawValue: 0)
    }
    
    @objc public func isCurrEventExist() -> Bool {
        var isEventExist = false;
        
        //print("\(#function)")
        
        dqInputEvents.sync(execute: {
            isEventExist = (nil != self.aEvent)
            //print("\(#function)", (nil != self.aEvent))
        })
                
        return isEventExist
    }

    // Darth: So I reaaally have to make these Objective-C? :(
    
    @objc func setAppActive() {
        //print("\(#function)")
        setActive(true)
    }
    
    @objc func setAppInactive() {
        //print("\(#function)")
        setActive(false)
    }
    
}

// ********* [not part of class] ***************************
func setGameCell() {
    print("\(#function)")
    //GameSceneVars.scene?.setCell()
}
