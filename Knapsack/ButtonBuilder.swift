//
//  ButtonBuilder.swift
//  Game1
//
//  Created by Emil Axelsson on 20/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class ButtonBuilder {
    
    func buildButton(guts : ButtonGuts) -> Button {
        var containerNode = ContainerButtonNode()
        var worldNode = WorldButtonNode()
        
        containerNode.setContents(guts.getContainerNodeContents());
        worldNode.setContents(guts.getWorldNodeContents());
        
        var button = Button(guts: guts, worldNode: worldNode, containerNode: containerNode)
        return button
    }    
}