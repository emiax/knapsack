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
    private var hardware : SKShapeNode;
    
    func setButton(button: Button) {
        self.button = button
    }
    
    func setContents(contents: SKNode) {
        removeAllChildren()
        self.addChild(hardware)
        contents.zPosition = ZLayer.ContainerButtonContent.toRaw()
        self.addChild(contents);
    }
    
    override init () {
        let w:CGFloat = 66;
        let h:CGFloat = 64;
        let radius:CGFloat = 7;
        
        self.hardware = SKShapeNode(rect: CGRect(x: -w/2, y: -h/2 + CGFloat(1), width: w, height: h), cornerRadius: radius)
        self.hardware.fillColor = UIColor(red: 0.847, green: 0.522, blue: 0.0, alpha: 0.6)
        self.hardware.lineWidth = 0
        self.hardware.zPosition = ZLayer.ContainerButtonHardware.toRaw();
        super.init()
        self.addChild(hardware)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func onPressed(t: UITouch) {
        self.touch = t;
        if let b = button {
            b.onPressed();
        }
        self.hardware.fillColor = UIColor(red: 0.847, green: 0.522, blue: 0.0, alpha: 1.0)
    }

    func onReleased(t: UITouch) {
        self.touch = nil;
        if let b = button {
            b.onReleased();
        }
        self.hardware.fillColor = UIColor(red: 0.847, green: 0.522, blue: 0.0, alpha: 0.6)
    }

    
    func getSize() -> CGSize {
        return CGSize(width: 48, height: 48)
    }
    
    func getBounds() -> CGRect {
        return CGRect(origin: CGPoint(x: -24, y: -24), size: CGSize(width: 48, height: 48))
    }
}
