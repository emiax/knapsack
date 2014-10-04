//
//  Contact.swift
//  Game1
//
//  Created by Emil Axelsson on 25/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class Contact : Equatable {
    init (spriteKitContact: SKPhysicsContact, coordinateSystem: SKNode, owner: SKNode) {
        self.spriteKitContact = spriteKitContact
        contactPoint = owner.convertPoint(spriteKitContact.contactPoint, fromNode: coordinateSystem)
        if (spriteKitContact.bodyA.node == owner) {
            other = spriteKitContact.bodyB.node!
        } else {
            other = spriteKitContact.bodyA.node!
        }
    }
    var spriteKitContact : SKPhysicsContact
    var contactPoint : CGPoint
    var other : SKNode
}

func == (lhs: Contact, rhs: Contact) -> Bool {
    return lhs.spriteKitContact == rhs.spriteKitContact
}