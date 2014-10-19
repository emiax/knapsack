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

    }
    
    func onReleased() {

    }
    
    func onPressedTick(currentTime: CFTimeInterval) {
        mainCharacter.walkLeft()
    }


    func onReleasedTick(currentTime: CFTimeInterval) {
        // do nothing
    }
    
    func getWorldNodeContents() -> SKNode {
        if let c = worldNodeContents {
            return c;
        } else {
            let c = SKSpriteNode(imageNamed: "LeftButton");
            c.setScale(0.8)
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