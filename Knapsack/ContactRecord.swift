//
//  File.swift
//  Game1
//
//  Created by Emil Axelsson on 25/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

protocol ContactRecord {
    func addContact(contact: Contact)
    func removeContact(contact: Contact)
}