
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
    
    private var touch : UITouch?
    
    private var thrower : Thrower
    
    init(thrower: Thrower) {
        self.thrower = thrower
        super.init()
        self.userInteractionEnabled = true
        self.zPosition = 1
        
//        let rect = SKShapeNode(rectOfSize: CGSize(width: 100, height: 100));
//       rect.fillColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
//       rect.userInteractionEnabled = true
//        addChild(rect)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touchObject : AnyObject in touches {
            if let t = touchObject as? UITouch {
                if let sn = shapeNode {
                    if sn.containsPoint(t.locationInNode(shapeNode)) {
                        self.touch = t
                        thrower.enterThrowMode()
                    }
                }
            }
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touchObject : AnyObject in touches {
            if let t = touchObject as? UITouch {
                if t === self.touch {
                    var touchOffset = t.locationInNode(self)
                    var nodeOffset = self.position
                    
                    thrower.setThrowOffset(CGVector(dx: touchOffset.x, dy: touchOffset.y))
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
