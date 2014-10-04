//
//  LeftButton.swift
//  Game1
//
//  Created by Emil Axelsson on 18/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class JumpButton : ButtonGuts {
    
    private var worldNodeContents : SKNode?
    private var containerNodeContents : SKNode?
    private var mainCharacter : MainCharacter;
    
    init(mainCharacter c : MainCharacter) {
        mainCharacter = c;
    }
    
    func onPressed() {
        mainCharacter.jump()
    }
    
    func onReleased() {
//        println("RELEASED JUMP");
    }
    
    func onPressedTick(currentTime: CFTimeInterval) {
/*        if (mainCharacter.isOnGround()) {
            println("resting!")
            mainCharacter.physicsBody?.velocity.dy += 500;
        }
        println("jump!")*/
    }
    
    func onReleasedTick(currentTime: CFTimeInterval) {
        // do nothing
    }
    
    func getWorldNodeContents() -> SKNode {
        if let c = worldNodeContents {
            return c;
        } else {
            let c = SKSpriteNode(imageNamed: "JumpButton");
            worldNodeContents = c;
            return c;
        }
    }
    
    func getContainerNodeContents() -> SKNode {
        if let c = containerNodeContents {
            return c;
        } else {
            let c = SKSpriteNode(imageNamed: "JumpButton");
            containerNodeContents = c;
            return c;
        }
    };
    
}