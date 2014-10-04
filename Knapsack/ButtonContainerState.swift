//
//  ButtonContainerState.swift
//  Game1
//
//  Created by Emil Axelsson on 27/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

protocol ButtonContainerState {
    func press(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint)
    func drag(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint)
    func release(slot: ButtonSlot?, touchEvent: UITouch, position: CGPoint)
}
