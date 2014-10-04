
//
//  MainCharacternOde.swift
//  Game1
//
//  Created by Emil Axelsson on 27/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit


class MainCharacterNode : SKNode {
    
    
    private var shapeNode: SKNode?
    
    private var hitCircle: SKNode
    
    private var touch : UITouch?
    
    private var thrower : Thrower
    
    init(thrower: Thrower) {
        self.thrower = thrower
        let hc = SKShapeNode(circleOfRadius: 50)
        hitCircle = hc

        super.init()
        self.userInteractionEnabled = true
        self.zPosition = 1
        
//       rect.fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
//       rect.userInteractionEnabled = true
        addChild(hc)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touchObject : AnyObject in touches {
            if let t = touchObject as? UITouch {
                if hitCircle.containsPoint(t.locationInNode(hitCircle)) {
                    self.touch = t
                    thrower.enterThrowMode(t)
                }
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touchObject : AnyObject in touches {
            if let t = touchObject as? UITouch {
                if t === self.touch {
                    thrower.updateThrowMode()
                }
            }
        }

    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touchObject : AnyObject in touches {
            if let t = touchObject as? UITouch {
                if t === self.touch {
                    throwOrLeave(t)
                    self.touch = nil
                }
            }
        }
    }
    
    func throwOrLeave(t: UITouch) {
        if (thrower.hasEnoughOffset()) {
            thrower.throwButton()
        }
        thrower.leaveThrowMode()
    }
    
    func updatePath(path: CGMutablePath, lineWidth: CGFloat) {
        shapeNode?.removeFromParent()

        let node = SKShapeNode(path: path)
        node.lineWidth = lineWidth
        node.fillColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addChild(node)
        shapeNode = node
    }
    
}
