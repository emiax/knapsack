//
//  Thrower.swift
//  Game1
//
//  Created by Emil Axelsson on 30/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

protocol Thrower {
    func enterThrowMode(touch: UITouch) -> Bool
    func leaveThrowMode() -> Bool
    func throwButton() -> Bool
    func updateThrowMode()
    func hasEnoughOffset() -> Bool
}