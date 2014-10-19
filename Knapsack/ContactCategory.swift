//
//  ContactCategory.swift
//  Game1
//
//  Created by Emil Axelsson on 15/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

enum ContactCategory:UInt32  {
    case None = 0
    case MainCharacter = 1
    case World = 2
    case Danger = 4
    case WorldButton = 8
    case Goal = 16
    case Interface = 32
}