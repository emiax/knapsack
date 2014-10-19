//
//  ViewManager.swift
//  Game1
//
//  Created by Emil Axelsson on 22/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class ViewManager {
    
    private var world : SKNode
    private var followee : SKNode?
    private var size : CGSize
    
    init(world: SKNode) {
        self.world = world
        size = CGSizeMake(0, 0)
    }
    
    func setFollowee(followee: SKNode) {
        self.followee = followee
    }

    func setSize(size : CGSize) {
        self.size = size
    }
    
    func update(currentTime : CFTimeInterval) {
        if let f = followee {
            var oldPos = world.position;
            var targetPos = CGPoint(x: -f.position.x + size.width/2, y: -f.position.y + size.height/2)
            world.position.x = oldPos.x*0.95 + targetPos.x*0.05
            world.position.y = oldPos.y*0.95 + targetPos.y*0.05
        }
    }
    
}