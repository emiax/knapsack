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
    private var collidable: Bool
    
    override init () {
        collidable = true
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCollidable(enabled: Bool) {
        self.collidable = enabled
        updateCollidable()
    }
    

    func updateCollidable() {
        if (collidable) {
            physicsBody?.contactTestBitMask = ContactCategory.World.toRaw() | ContactCategory.World.toRaw() | ContactCategory.MainCharacter.toRaw()
        } else {
            physicsBody?.contactTestBitMask = ContactCategory.None.toRaw();
        }
    }
    
    func setButton(button: Button) {
        self.button = button
    }
    
    func setContents(contents: SKNode) {
        removeAllChildren()
        self.addChild(contents);
        
        let p = SKPhysicsBody(rectangleOfSize: getSize());
        p.categoryBitMask = ContactCategory.WorldButton.toRaw()
        p.friction = 0
        
        physicsBody = p
        updateCollidable()
    }
    
    func getSize() -> CGSize {
        return CGSize(width: 48, height: 48)
    }
}
