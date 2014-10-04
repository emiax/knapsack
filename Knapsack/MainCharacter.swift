//
//  MainCharacterBuilder.swift
//  Game1
//
//  Created by Emil Axelsson on 15/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class MainCharacter {
    
    private var contacts: [Contact] = []
    
    required init () {
        offsetFollowingNode = CGVector(dx: 0, dy: 0)
    }
    
    let nPerimeterNodes = 12
    let nodeRadius:CGFloat = 7
    let nodeSeparation:CGFloat = 20
    let PI:CGFloat = 3.141596
    
    let frequency:CGFloat = 7
    let damping:CGFloat = 10
    
    private var attachedNodes = false;
    private var centerNode:SKNode?
    private var followingNode:SKNode?
    private var perimeterNodes:[SKNode] = []
    
    private var visibleNode:MainCharacterNode?
    private var parent:SKNode?
    private var offsetFollowingNode:CGVector
    private var touch : UITouch?
    
    
    func angleOfNode(i:Int) -> CGFloat {
        return CGFloat(i)/CGFloat(nPerimeterNodes) * 2.0 * PI;
    }
    
    func getFollowingNode() -> SKNode? {
        return followingNode
    }
    
    func getCenterNode() -> SKNode? {
        return centerNode
    }
    
    func getPosition() -> CGPoint? {
        return centerNode?.position
    }
    
    func setElastic(elasticOffset: CGVector?) {
        if let eo = elasticOffset {
            offsetFollowingNode = CGVector(dx: eo.dx/3, dy: eo.dy/3 + 50)
        } else {
            offsetFollowingNode = CGVector(dx: 0, dy: 0)
        }
    }
    
    func attachNodes(parent: SKNode, physicsWorld: SKPhysicsWorld, thrower: Thrower) {
        if attachedNodes { return }
        
        let fn = SKNode();
        
        self.parent = parent
        let cn = SKShapeNode(circleOfRadius: nodeRadius)
        cn.hidden = true
        
        let cnp = SKPhysicsBody(circleOfRadius: nodeRadius)
        cn.physicsBody = cnp
        
        parent.addChild(cn)
        
        cnp.categoryBitMask = ContactCategory.MainCharacter.toRaw()
        cnp.contactTestBitMask = ContactCategory.World.toRaw()
        cnp.collisionBitMask = ContactCategory.World.toRaw()
        cnp.affectedByGravity = false
        
        for (var i = 0; i < nPerimeterNodes; i++) {
            let s = SKShapeNode(circleOfRadius: nodeRadius)
            s.hidden = true;
            
            perimeterNodes.append(s)
            parent.addChild(s)

            let p = SKPhysicsBody(circleOfRadius: nodeRadius)
            s.physicsBody = p
            
            p.categoryBitMask = ContactCategory.MainCharacter.toRaw()
            p.contactTestBitMask = ContactCategory.World.toRaw()
            p.collisionBitMask = ContactCategory.World.toRaw()
            p.friction = 200
            p.allowsRotation = false
            
            let currentAngle = angleOfNode(i);
            let currentX = nodeSeparation*cos(currentAngle);
            let currentY = nodeSeparation*sin(currentAngle);
            
            s.position.x = currentX
            s.position.y = currentY
            
            let centerJoint = SKPhysicsJointSpring.jointWithBodyA(cnp,
                bodyB: p,
                anchorA: CGPoint(x: 0, y: 0),
                anchorB: CGPoint(x: currentX, y: currentY))
            
            centerJoint.damping = damping
            centerJoint.frequency = frequency

            
            physicsWorld.addJoint(centerJoint)
            
            if (i > 0) {
                let previousNode = perimeterNodes[i - 1];
                let previousAngle = angleOfNode(i - 1);
                
                let previousAnchor = CGPoint(x: nodeSeparation*cos(previousAngle), y: nodeSeparation*sin(previousAngle))
                let currentAnchor = CGPoint(x: nodeSeparation*cos(currentAngle), y: nodeSeparation*sin(currentAngle))
                
                if let previousBody = previousNode.physicsBody {
                    let perimeterJoint = SKPhysicsJointSpring.jointWithBodyA(previousBody,
                        bodyB: p,
                        anchorA: previousAnchor,
                        anchorB: currentAnchor)
                    
                    perimeterJoint.frequency = frequency
                    perimeterJoint.damping = damping
                    
                    physicsWorld.addJoint(perimeterJoint)
                }
            }
        }
        
        if let first = perimeterNodes.first?.physicsBody {
            if let last = perimeterNodes.last?.physicsBody {
            
                let firstAngle = angleOfNode(0);
                let lastAngle = angleOfNode(nPerimeterNodes - 1);
                
                let firstAnchor = CGPoint(x: nodeSeparation*cos(firstAngle), y: nodeSeparation*sin(firstAngle))
                let lastAnchor = CGPoint(x: nodeSeparation*cos(lastAngle), y: nodeSeparation*sin(lastAngle))
            
                let perimeterJoint = SKPhysicsJointSpring.jointWithBodyA(last,
                    bodyB: first,
                    anchorA: lastAnchor,
                    anchorB: firstAnchor)
            
                perimeterJoint.frequency = frequency
                perimeterJoint.damping = damping
                
                physicsWorld.addJoint(perimeterJoint)
            }
        }
        
        let vn = MainCharacterNode(thrower: thrower)
        visibleNode = vn
        updateVisibleNode()
        parent.addChild(vn)

        centerNode = cn
        followingNode = fn
        attachedNodes = true
    }
    
    func updateFollowingNode () {
        if let cn = centerNode {
            if let fn = followingNode {
                fn.position = cn.position
                fn.position.x += offsetFollowingNode.dx
                fn.position.y += offsetFollowingNode.dy
            }
        }
    }
    
    func updateVisibleNode() {
        if let cPosition = centerNode?.position {
            visibleNode?.position = cPosition
            
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, perimeterNodes.first!.position.x - cPosition.x, perimeterNodes.first!.position.y - cPosition.y)
            for (var i = 1; i < perimeterNodes.count; i++) {
                CGPathAddLineToPoint (path, nil, perimeterNodes[i].position.x - cPosition.x, perimeterNodes[i].position.y - cPosition.y);
                
            }
            CGPathCloseSubpath(path)
            visibleNode?.updatePath(path, lineWidth: 2.2 * nodeRadius)
        }
    }
    
   
    func walkLeft() {
         walk(-6000)
    }
    
    func walkRight() {
        walk(6000)
    }

    func walk(x: CGFloat) {
        let direction:CGFloat = x > 0 ? 1.0 : -1.0
        if let c = centerNode {
            for node in perimeterNodes {
                if let cVel = c.physicsBody?.velocity {
                    if let nodeVel = node.physicsBody?.velocity {
                        
                        let xDiff = node.position.x - c.position.x
                        let yDiff = node.position.y - c.position.y
                        let rotationVect = CGVector(yDiff, -xDiff)
                        
                        var nodeVel = CGVector(dx: nodeVel.dx - cVel.dx,
                            dy: nodeVel.dy - cVel.dy)
                        
                        var current = nodeVel.dx * rotationVect.dx + nodeVel.dy * rotationVect.dy
                        let coeff = max(abs(x) - abs(current), 0)/abs(x)
                        
                        node.physicsBody?.applyForce(CGVector(dx: yDiff*coeff*direction,
                            dy: -xDiff*coeff*direction))
                    }
                }
            }
        }
    }

    
    func jump() {
        for node in perimeterNodes {
            if let c = centerNode {
                node.physicsBody!.applyForce(CGVector(dx: 0, dy: 200))
            }
        }
    }
    
    func throwButton(buttonNode : WorldButtonNode, elasticOffset: CGVector) -> Bool {
        if let p = getPosition() {
            buttonNode.removeFromParent()
            parent?.addChild(buttonNode)
            buttonNode.position = CGPoint(x: p.x + elasticOffset.dx, y: p.y + elasticOffset.dy)
//            buttonNode.physicsBody?.velocity = velocity
            return true
        }
        return false
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func isOnGround() -> Bool {
        println("Is on ground?")
        
        for c in contacts {
            if (c.contactPoint.y < -10) {
                println("point: \(c.contactPoint)")
                return true
            }
        }
        return false
    }

    func update() {
        updateFollowingNode()
        updateVisibleNode()
    }

}