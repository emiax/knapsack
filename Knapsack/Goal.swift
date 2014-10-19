//
//  Goal.swift
//  Game1
//
//  Created by Emil Axelsson on 18/10/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class Goal : SKNode {
    
    override init() {
        super.init()
        let p = SKPhysicsBody(circleOfRadius: 50)
        p.collisionBitMask = ContactCategory.Goal.toRaw()
        self.physicsBody = p;
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
