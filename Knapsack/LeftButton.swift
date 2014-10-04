//
//  LeftButton.swift
//  Game1
//
//  Created by Emil Axelsson on 18/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class LeftButton : ButtonGuts {
    
    private var worldNodeContents : SKNode?
    private var containerNodeContents : SKNode?
    private var mainCharacter : MainCharacter;
    
    init(mainCharacter c : MainCharacter) {
        mainCharacter = c;
    }
    
    func onPressed() {
//        println("PRESSED LEFT");
    }
    
    func onReleased() {
//        println("RELEASED LEFT");
    }
    
    func onPressedTick(currentTime: CFTimeInterval) {
/*        if let v = mainCharacter.physicsBody?.velocity {
            let coeff = -2 - v.dx;
            if (coeff < 0) {
                mainCharacter.physicsBody?.applyForce(CGVector(coeff * 5, 0))
            }
        }*/
        mainCharacter.walkLeft()
//            physicsBody?.velocity.dx = -100
//        println("walk left")
    }
    
    func onReleasedTick(currentTime: CFTimeInterval) {
        // do nothing
    }
    
    func getWorldNodeContents() -> SKNode {
        if let c = worldNodeContents {
            return c;
        } else {
            let c = SKSpriteNode(imageNamed: "LeftButton");
            worldNodeContents = c;
            return c;
        }
    }
    
    func getContainerNodeContents() -> SKNode {
        if let c = containerNodeContents {
            return c;
        } else {
            let c = SKSpriteNode(imageNamed: "LeftButton");
            containerNodeContents = c;
            return c;
        }
    };
    
}