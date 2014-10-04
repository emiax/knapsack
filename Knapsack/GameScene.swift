//
//  GameScene.swift
//  Game1
//
//  Created by Emil Axelsson on 10/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var groundPhysics: [SKPhysicsBody] = []
    var mainCharacter: MainCharacter?
    var buttonContainer : ButtonContainer?
    var viewManager : ViewManager?
    var world : SKNode?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func didMoveToView(view: SKView) {
        if view.frame.height > view.frame.width {
            println("moved into wrong view. fix this.")
            return
        }
        
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)

        var level = Level1();

        // button container
//        let bc = level.buttonContainer()
        
        let bc = level.getButtonContainer()
        self.addChild(bc)
        bc.position = CGPoint(x: 0, y: 0);
        bc.setSize(view.bounds.size)
        buttonContainer = bc
        
        // world
        let world = level.getWorld();
        self.addChild(world);
        
        self.world = world

        // add character to world
        let mc = level.getMainCharacter()
        mc.attachNodes(world, physicsWorld: physicsWorld, thrower: bc)
        

        self.viewManager = ViewManager(world: world);
        self.viewManager!.setSize(view.bounds.size);
        
        if let fn = mc.getFollowingNode() {
            viewManager?.setFollowee(fn);
        }
        mainCharacter = mc
        
        self.physicsWorld.contactDelegate = self;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self);

            //let physics = mainCharacter.physicsBody;
/*            if self.nodeAtPoint(location) == mainCharacter {
                mainCharacter.
            }*/
            

        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
//            println(touch);
        }
    }

    
    func tryPickUp(buttonNode : WorldButtonNode) -> Bool {
        if let b = buttonNode.button {
            if let bc = buttonContainer {
                if (bc.addButton(b)) {
                    buttonNode.removeFromParent()
                    return true
                }
            }
        }
        return false
    }
    

    
    func didBeginContact(contact: SKPhysicsContact) {
        /*if let cr = contact.bodyA.node as? MainCharacter {
            cr.addContact(Contact(spriteKitContact: contact, coordinateSystem: self, owner: contact.bodyA.node!))
        }
        if let cr = contact.bodyB.node as? MainCharacter {
            cr.addContact(Contact(spriteKitContact: contact, coordinateSystem: self, owner: contact.bodyB.node!))
        }*/
        
        if (contact.bodyA.categoryBitMask == ContactCategory.MainCharacter.toRaw()) {
            if let b = contact.bodyB.node as? WorldButtonNode {
                tryPickUp(b);
            }
        }
        if (contact.bodyB.categoryBitMask == ContactCategory.MainCharacter.toRaw()) {
            if let b = contact.bodyA.node as? WorldButtonNode {
                tryPickUp(b);
            }
        }
    }
   
    func didEndContact(contact: SKPhysicsContact) {
        /*if let cr = contact.bodyA.node as? MainCharacter {
            cr.removeContact(Contact(spriteKitContact: contact, coordinateSystem: self, owner: contact.bodyA.node!))
        }
        if let cr = contact.bodyB.node as? MainCharacter {
            cr.removeContact(Contact(spriteKitContact: contact, coordinateSystem: self, owner: contact.bodyB.node!))
        }*/
    }

    override func didApplyConstraints() {
        mainCharacter?.update()
    }
    
    override func update(currentTime: CFTimeInterval) {
        buttonContainer!.update(currentTime)
        viewManager?.update(currentTime)
    }
}
