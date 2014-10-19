//
//  GameScene.swift
//  Game1
//
//  Created by Emil Axelsson on 10/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var mainCharacter: MainCharacter?
    var buttonContainer : ButtonContainer?
    var viewManager : ViewManager?
    var world : SKNode?
//    var view : SKView?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    override func didMoveToView(view: SKView) {
        if view.frame.height > view.frame.width {
            println("moved into wrong view. fix this.")
            return
        }
        
        self.backgroundColor = UIColor(red: 0.8, green: 0.8, blue: 1.0, alpha: 1.0)
        //self.view = view;
        loadLevel()
        // button container
//        let bc = level.buttonContainer()
        

        
        
    }
    
    
    func reload() {
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            // Configure the view.
            if let skView = self.view {
                skView.showsFPS = false
                skView.showsNodeCount = false
            
                /* Sprite Kit applies additional optimizations to improve rendering performance */
                skView.ignoresSiblingOrder = true
                scene.size = skView.bounds.size
            
            
                /* Set the scale mode to scale to fit the window */
                scene.scaleMode = .AspectFill
            
                skView.presentScene(scene)
            }
        }
        
    }
    
    func loadLevel() {
        if let v = self.view {
            self.removeAllChildren()
            
            let loader = LevelLoader()
            var level = loader.loadLevel("http://emilaxelsson.se/knapsack/level1")

            let bc = level.getButtonContainer()
            self.addChild(bc)
            bc.position = CGPoint(x: 0, y: 0);
            bc.setSize(v.bounds.size)
            buttonContainer = bc
            
            // world
            let world = level.getWorld();
            self.addChild(world);
        
            self.world = world
        
            // add character to world
            let mc = level.getMainCharacter()
            
            mc.attachNodes(world, physicsWorld: physicsWorld, thrower: bc)
        println(mc.getPosition())
        
            self.viewManager = ViewManager(world: world);
            self.viewManager!.setSize(v.bounds.size);
        
            if let fn = mc.getFollowingNode() {
                viewManager?.setFollowee(fn);
            }
            mainCharacter = mc
        
            self.physicsWorld.contactDelegate = self;
        }
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
        if (buttonNode.isPickable()) {
            if let b = buttonNode.button {
                if let bc = buttonContainer {
                    if (bc.addButton(b)) {
                        buttonNode.removeFromParent()
                        return true
                    }
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
            if (contact.bodyB.categoryBitMask == ContactCategory.World.toRaw()) {
                mainCharacter?.addContact(contact);
            }
            if (contact.bodyB.categoryBitMask == ContactCategory.Danger.toRaw()) {
                println("KILLED")
//                loadLevel()
                reload()
            }
        }
        if (contact.bodyB.categoryBitMask == ContactCategory.MainCharacter.toRaw()) {
            if let b = contact.bodyA.node as? WorldButtonNode {
                tryPickUp(b);
            }
            if (contact.bodyA.categoryBitMask == ContactCategory.World.toRaw()) {
                mainCharacter?.addContact(contact);
            }
            if (contact.bodyA.categoryBitMask == ContactCategory.Danger.toRaw()) {
                println("KILLED")
//                loadLevel()
                reload()
            }
        }
    }
   
    func didEndContact(contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == ContactCategory.MainCharacter.toRaw()) {
            if (contact.bodyB.categoryBitMask == ContactCategory.World.toRaw()) {
                mainCharacter?.removeContact(contact);
            }
        }
        if (contact.bodyB.categoryBitMask == ContactCategory.MainCharacter.toRaw()) {
            if (contact.bodyA.categoryBitMask == ContactCategory.World.toRaw()) {
                mainCharacter?.removeContact(contact);
            }
            
        }
        
        
        /*if let cr = contact.bodyA.node as? MainCharacter {
            cr.removeContact(Contact(spriteKitContact: contact, coordinateSystem: self, owner: contact.bodyA.node!))
        }
        if let cr = contact.bodyB.node as? MainCharacter {
            cr.removeContact(Contact(spriteKitContact: contact, coordinateSystem: self, owner: contact.bodyB.node!))
        }*/
    }


    override func didApplyConstraints() {
        mainCharacter?.update()
        if let w = world {
            for c in w.children {
                if let node = c as? WorldButtonNode {
                    node.update()
                }
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        buttonContainer?.update(currentTime)
        viewManager?.update(currentTime)
    }
}
