//
//  ButtonManager.swift
//  Game1
//
//  Created by Emil Axelsson on 30/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//
/*
import SpriteKit

class ButtonManager : Thrower {
    
    private var bc : ButtonContainer
    private var offset : CGVector
    private var mainCharacter : MainCharacter
    private var elastic : SKShapeNode?
    
    init(mainCharacter: MainCharacter, level: Level) {
        bc = level.getButtonContainer();
        bc.setState(DefaultButtonContainerState())
        offset = CGVector(dx: 0, dy: 0)
        self.mainCharacter = mainCharacter
    }
    
    func getButtonContainer() -> ButtonContainer {
        return bc
    }
    
    func hasEnoughOffset() -> Bool {
        return sqrt(offset.dx * offset.dx + offset.dy + offset.dy) > 100
    }
    
    func enterThrowMode() -> Bool {
        bc.setState(ThrowButtonContainerState(container: bc))
        offset = CGVector(dx: 0, dy: 0)
        mainCharacter.extendElastic(offset)
        
        return true
    }
    
    
    func leaveThrowMode() -> Bool {
        mainCharacter.disableElastic()
        bc.setState(DefaultButtonContainerState())
        return true
    }
    
    func throwButton() -> Bool {
        if let button = bc.getThrowSlotButton() {
            if let worldNode = button.getWorldNode() {
                if (mainCharacter.throwButton(worldNode, elasticOffset: offset)) {
                    bc.removeButton(button)
                    return true
                }
            }
        }
        return false
    }
    
    func setThrowOffset(offset: CGVector) {
//        println("\(offset.dx), \(offset.dy)")
        self.offset = offset
        mainCharacter.extendElastic(offset)
    }
    
    func update(currentTime: CFTimeInterval) {
        bc.update(currentTime)
    }
    
    func addButton(button: Button) -> Bool {
        return bc.addButton(button)
    }
}
*/