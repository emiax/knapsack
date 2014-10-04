//
//  MainCharacterBuilder.swift
//  Game1
//
//  Created by Emil Axelsson on 15/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit




class Level1 : Level{
    
    private var buttonBuilder : ButtonBuilder
    
    override init() {
        buttonBuilder = ButtonBuilder()
        super.init()

    }
    
    override func createMainCharacter() -> MainCharacter {
        return MainCharacter()
    }
    
    override func createWorld() -> SKNode {
        var world = SKNode()
/*
        for (var i = 0; i < 10; i++) {
            var xPos : Int = (-100 + i*48);
            world.addChild(createWallElement(xPos, -100))
        }
        
        for (var i = 0; i < 10; i++) {
            var yPos : Int = (-100 + i*48);
            world.addChild(createWallElement(300, yPos))
        }
*/
        
        let points = [
            CGPoint(x: 1000, y: -100),
            CGPoint(x: 1000, y: -50),
            CGPoint(x: 800, y: -60),
            CGPoint(x: 600, y: -25),
            CGPoint(x: 450, y: -16),
            CGPoint(x: 350, y: -60),
            CGPoint(x: 0, y: -50),
            CGPoint(x: -200, y: -100)
            ]
        
        let path = createPathFromPoints(points)
        world.addChild(createWallShape(path))
        
        var b = buttonBuilder.buildButton(RightButton(mainCharacter: getMainCharacter()))
        
        var node = b.getWorldNode();
        if let n = node {
            n.position = CGPoint(x: 500, y: 200)
            world.addChild(n);
        }

        
        b = buttonBuilder.buildButton(JumpButton(mainCharacter: getMainCharacter()))
        
        node = b.getWorldNode();
        if let n = node {
            n.position = CGPoint(x: 800, y: 200)
            world.addChild(n);
        }


        
        
        return world;
    }
    
    
    
    override func createButtonContainer() -> ButtonContainer {
   
        let mc = getMainCharacter()
        
        var container = ButtonContainer(mainCharacter: mc)
        container.addSlot(ButtonSlot(), origin: ButtonContainer.SlotOrigin.BottomRight, alignment: ButtonContainer.SlotAlignment.Vertical)
        container.addSlot(ButtonSlot(), origin: ButtonContainer.SlotOrigin.BottomLeft, alignment: ButtonContainer.SlotAlignment.Vertical)

        container.addSlot(ButtonSlot(), origin: ButtonContainer.SlotOrigin.BottomLeft, alignment: ButtonContainer.SlotAlignment.Horizontal)

        
        container.addSlot(ButtonSlot(), origin: ButtonContainer.SlotOrigin.BottomLeft, alignment: ButtonContainer.SlotAlignment.Vertical)
        
        
        

        
        var b = buttonBuilder.buildButton(LeftButton(mainCharacter: mc))
        container.addButton(b)
        
        var c = buttonBuilder.buildButton(RightButton(mainCharacter: mc))
        container.addButton(c)
        
        var d = buttonBuilder.buildButton(JumpButton(mainCharacter: mc))
        container.addButton(d)
        
        
        return container
    }

}