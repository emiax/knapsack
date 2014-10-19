//
//  MainCharacterBuilder.swift
//  Game1
//
//  Created by Emil Axelsson on 15/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit




class LoadedLevel : Level{
    
    private var mc: MainCharacter
    private var w: SKNode
    private var sb: [Button]
    
    init(mainCharacter: MainCharacter, world : SKNode, spawnButtons: [Button]) {
        mc = mainCharacter
        w = world
        sb = spawnButtons
        
        super.init()
    }
    
    override func createMainCharacter() -> MainCharacter {
        return mc
    }
    
    override func createWorld() -> SKNode {
        return w
    }
    
    override func createButtonContainer() -> ButtonContainer {
        
        let mc = getMainCharacter()
        
        var container = ButtonContainer(mainCharacter: mc)
        
        container.addSlot(ButtonSlot(), origin: ButtonContainer.SlotOrigin.BottomRight, alignment: ButtonContainer.SlotAlignment.Vertical)
        container.addSlot(ButtonSlot(), origin: ButtonContainer.SlotOrigin.BottomLeft, alignment: ButtonContainer.SlotAlignment.Vertical)
        container.addSlot(ButtonSlot(), origin: ButtonContainer.SlotOrigin.BottomLeft, alignment: ButtonContainer.SlotAlignment.Horizontal)
        
        
//        container.addSlot(ButtonSlot(), origin: ButtonContainer.SlotOrigin.BottomLeft, alignment: ButtonContainer.SlotAlignment.Vertical)
        
        
        for button in sb {
            container.addButton(button);
        }
        
        
        
        return container
    }
    
}