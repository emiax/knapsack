//
//  DefaultButtonContainerState.swift
//  Game1
//
//  Created by Emil Axelsson on 29/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class DefaultButtonContainerState : ButtonContainerState {
    
    private var slotDict = Dictionary<UITouch, ButtonSlot>()
    private var touchDict = Dictionary<ButtonSlot, [UITouch]>()
    
    /**
    * Called when touch starts on button
    */
    func press(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint) {
        // add to touch->slot dict
        slotDict[touchEvent] = slot;
        if let s = slot {
            if (touchDict[s] == nil) {
                touchDict[s] = []
            }
            
            let touches = touchDict[s]!
            if (touches.isEmpty) {
                // press the button!
                pressButton(s, touchEvent: touchEvent)
                
            }
            touchDict[s]!.append(touchEvent)
        }
    }
    
    /**
    * Called when touch moves on button
    */
    func drag(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint) {
        if let previousSlot = slotDict[touchEvent] {
            if (slot === previousSlot) {
                return // nothing happened!
            } else {
                release(previousSlot, touchEvent: touchEvent, position: position)
            }
        } else {
            press(slot, touchEvent: touchEvent, position: position)
        }
    }
    
    /**
    * Called when touch is released on button
    */
    func release(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint) {
        // remove from touch->slot dict
        
        if let s = slotDict[touchEvent] {
            if (touchDict[s] == nil) {
                touchDict[s] = []
            }
            
            var touches = touchDict[s]!
            // search for touch in slot->touch dict and remove it if found
            var i = 0;
            while (i < touches.count) {
                var oldTouch = touches[i]
                if (oldTouch === touchEvent) {
                    touches.removeAtIndex(i)
                } else {
                    i++;
                }
            }
            
            touchDict[s] = touches
            if (touches.isEmpty) {
                // release the button!
                releaseButton(s, touchEvent: touchEvent)
                
            }
        }
        slotDict[touchEvent] = nil
    }
    
    /**
    * Actually press the button
    */
    private func pressButton(slot: ButtonSlot, touchEvent: UITouch) {
        slot.getButton()?.onPressed(touchEvent)
    }
    
    /**
    * Actually release the button
    */
    private func releaseButton(slot: ButtonSlot, touchEvent: UITouch) {
        slot.getButton()?.onReleased(touchEvent)
    }
}
