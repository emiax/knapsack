//
//  File.swift
//  Game1
//
//  Created by Emil Axelsson on 20/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

protocol ButtonGuts {
    func onPressed()
    func onReleased()
    func onPressedTick(currentTime: CFTimeInterval)
    func onReleasedTick(currentTime: CFTimeInterval)
    
    func getWorldNodeContents() -> SKNode;
    func getContainerNodeContents() -> SKNode;
}