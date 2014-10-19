//
//  ButtonWorldSprite.swift
//  Game1
//
//  Created by Emil Axelsson on 20/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class WorldButtonNode : SKNode {
    
    var button : Button?
    private var temporalilyUnpickable: Bool
    private var hardware : SKShapeNode;    
    
    override init () {
        temporalilyUnpickable = false
        
        let w = CGFloat(52)
        let h = CGFloat(52)
        
        self.hardware = SKShapeNode(rect: CGRect(x: -w/2, y: -h/2 + CGFloat(1), width: w, height: h), cornerRadius: 5)
        self.hardware.fillColor = UIColor(red: 0.847, green: 0.522, blue: 0.0, alpha: 0.9)
        self.hardware.lineWidth = 0
        self.hardware.zPosition = ZLayer.WorldButtonHardware.toRaw();
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeTemporarilyUnpickable() {
        temporalilyUnpickable = true
        updatePickable()
    }
    
    func isPickable() -> Bool {
        return !temporalilyUnpickable
    }
    
    
    func updatePickable() {
        if (temporalilyUnpickable) {
//            println("Setting to world only")
            physicsBody?.collisionBitMask = ContactCategory.World.toRaw()
        } else {
           // println("Setting to world and character")
            physicsBody?.collisionBitMask = ContactCategory.World.toRaw() | ContactCategory.MainCharacter.toRaw()
        }
    }
    
    func update() {
        if (temporalilyUnpickable) {

            if let p = self.physicsBody {
                let bodies = p.allContactedBodies()
                var stillContact = false
                for b in bodies {
                    if (b.categoryBitMask == ContactCategory.MainCharacter.toRaw()) {
                        stillContact = true
                    }
                }
                if (!stillContact) {
                    temporalilyUnpickable = false
                    updatePickable()
                }
            }
        }
    }
    
    func setButton(button: Button) {
        self.button = button
    }
    
    func setContents(contents: SKNode) {
        removeAllChildren()
        self.addChild(contents);
        contents.zPosition = ZLayer.WorldButtonContent.toRaw();
        self.addChild(hardware)
        
        let p = SKPhysicsBody(rectangleOfSize: getSize());
        p.categoryBitMask = ContactCategory.WorldButton.toRaw()
        p.contactTestBitMask = ContactCategory.World.toRaw() | ContactCategory.MainCharacter.toRaw()
        p.friction = 2.0
        
        physicsBody = p
        updatePickable()
    }
    
    func getSize() -> CGSize {
        return CGSize(width: 46, height: 46)
    }
}
