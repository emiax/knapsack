//
//  DefaultButtonContainerState.swift
//  Game1
//
//  Created by Emil Axelsson on 29/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class ThrowButtonContainerState : ButtonContainerState {
    
    private var slotDict = Dictionary<UITouch, ButtonSlot>()
    private var touchDict = Dictionary<ButtonSlot, [UITouch]>()
    private var container: ButtonContainer;
    
    init (container: ButtonContainer) {
        self.container = container
    }
    
    /**
     * Called when touch starts on button
     */
    func press(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint) {
        println("PRESS")
        if let s = slot {
            if (!s.isEmpty()) {
                container.selectThrowSlot(s)
            }
        }
     }
    
    /**
     * Called when touch moves on button
     */
    func drag(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint) {
        println("DRAG")
    }
    
    /**
     * Called when touch is released on button
     */
    func release(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint) {
        println("RELEASE")
    }
    
}
