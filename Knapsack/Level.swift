//
//  Level.swift
//  Game1
//
//  Created by Emil Axelsson on 18/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit


func createWallElement(x: Int, y: Int) -> SKSpriteNode {
    var s = SKSpriteNode(imageNamed: "Wall");
    var p = SKPhysicsBody(rectangleOfSize: s.size);
    
    p.categoryBitMask = ContactCategory.World.toRaw()
    p.contactTestBitMask = ContactCategory.World.toRaw()
    p.friction = 10000
    p.dynamic = false
    s.position = CGPoint(x: x,y: y);
    s.physicsBody = p
    return s
}

func createWallShape(path: CGMutablePath) -> SKShapeNode {
    var s = SKShapeNode(path: path)
    var p = SKPhysicsBody(edgeLoopFromPath: path)
    
    s.fillColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0)
    
    p.categoryBitMask = ContactCategory.World.toRaw()
    p.contactTestBitMask = ContactCategory.World.toRaw()
    p.friction = 0.1
    p.dynamic = false
    s.position = CGPoint(x: 0,y: 0);
    s.physicsBody = p
    
    return s
}

func createPathFromPoints(shapePoints: [CGPoint]) -> CGMutablePath {
    var path = CGPathCreateMutable();

    CGPathMoveToPoint (path, nil, shapePoints[0].x, shapePoints[0].y);
    for (var k = 1; k < shapePoints.count; k++) {
        CGPathAddLineToPoint (path, nil, shapePoints[k].x, shapePoints[k].y);
    }
    CGPathCloseSubpath(path)
    return path
}


class Level {
    
    init() {
        
    }
    
    private var world : SKNode?
    
    private var mainCharacter : MainCharacter?

    private var buttonContainer : ButtonContainer?
    
    func getWorld() -> SKNode {
        if let w = world {
            return w
        }
        let w = createWorld()
        world = w
        return w
    }
    
    func getMainCharacter() -> MainCharacter {
        if let c = mainCharacter {
            return c
        }
        let c = createMainCharacter()
        mainCharacter = c
        return c
    }
    
    func getButtonContainer() -> ButtonContainer {
        if let bc = buttonContainer {
            return bc
        }
        let bc = createButtonContainer()
        buttonContainer = bc
        return bc
    }
    
    func createWorld() -> SKNode { return SKNode() }
    
    func createMainCharacter() -> MainCharacter { return MainCharacter() }
    
    func createButtonContainer() -> ButtonContainer { return ButtonContainer(mainCharacter: getMainCharacter()) }
    
    func clear() {
        world = nil
        mainCharacter = nil
        buttonContainer = nil
    }

}