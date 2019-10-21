//
//  GameScene.swift
//  Brogue
//
//  Created by Raymund Vidar on 10/11/19.
//  Copyright © 2019 darthvid. All rights reserved.
//

import SpriteKit
//import GameplayKit



 class GameScene: SKScene {
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override public func didMove(to view: SKView) {
        // Darth: View is up?
        print("\(#function)")
        
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
        
        
        // Init the Wrapper.
        WrapperGlobals.scene = self
        WrapperGlobals.wrapper = Wrapper()
        // Tigger game loop.
        WrapperGlobals.wrapper?.runGameLoop()
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
            print("\(event.characters!) keyCode: \(event.keyCode) cim: \(event.charactersIgnoringModifiers!)")
        }
        //print(event.charactersIgnoringModifiers!)
        
        WrapperGlobals.wrapper?.setInputEvent(event)
    }
    
    
    override public func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    
    override public func sceneDidLoad() {
        // Darth: Scene is loaded, but view is not yet up?
        print("\(#function)")
    }
}
