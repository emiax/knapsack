//
//  ContainerButtonSprite.swift
//  Game1
//
//  Created by Emil Axelsson on 20/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class ContainerButtonNode : SKNode {
 
    var button : Button?
    var touch : UITouch?;
    
    
    func setButton(button: Button) {
        self.button = button
    }
    
    func setContents(contents: SKNode) {
        removeAllChildren()
        self.addChild(contents);
    }
    
    override init () {
        super.init()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onPressed(t: UITouch) {
        self.touch = t;
        if let b = button {
            b.onPressed();
        }
    }

    func onReleased(t: UITouch) {
        self.touch = nil;
        if let b = button {
            b.onReleased();
        }
    }

    
    func getSize() -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func getBounds() -> CGRect {
        return CGRect(origin: CGPoint(x: -24, y: -24), size: CGSize(width: 48, height: 48))
    }
}
