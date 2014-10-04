//
//  Button.swift
//  Game1
//
//  Created by Emil Axelsson on 15/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//
import Foundation

class Button {
    
    private var worldNode : WorldButtonNode?;
    private var containerNode : ContainerButtonNode?;
    private var guts : ButtonGuts;
    
    private var down = false;
    
    init(guts : ButtonGuts, worldNode : WorldButtonNode, containerNode: ContainerButtonNode) {
        self.worldNode = worldNode
        self.containerNode = containerNode
        self.guts = guts

        worldNode.setButton(self);
        containerNode.setButton(self);
    }

    func getWorldNode() -> WorldButtonNode? {
        return worldNode;
    }
    
    func getContainerNode() -> ContainerButtonNode? {
        return containerNode;
    }
    
    func onPressed() {
        guts.onPressed();
        down = true
    }
    
    func onReleased() {
        guts.onReleased();
        down = false
    }
    
    func update(currentTime: CFTimeInterval) {
        if (down) {
            guts.onPressedTick(currentTime)
        } else {
            guts.onReleasedTick(currentTime)
        }
    }
    
    func isPressed() -> Bool {
        return down
    }
}
