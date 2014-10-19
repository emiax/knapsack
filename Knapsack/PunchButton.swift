//
//  PunchButton.swift
//  Knapsack
//
//  Created by Emil Axelsson on 19/10/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class PunchButton : ButtonGuts {
    
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
        mainCharacter.punch()
    }
    
    func onReleasedTick(currentTime: CFTimeInterval) {
    }
    
    func getWorldNodeContents() -> SKNode {
        if let c = worldNodeContents {
            return c;
        } else {
            let c = SKSpriteNode(imageNamed: "PunchButton");
            c.setScale(0.8)
            worldNodeContents = c;
            return c;
        }
    }
    
    func getContainerNodeContents() -> SKNode {
        if let c = containerNodeContents {
            return c;
        } else {
            let c = SKSpriteNode(imageNamed: "PunchButton");
            containerNodeContents = c;
            return c;
        }
    };
    
}