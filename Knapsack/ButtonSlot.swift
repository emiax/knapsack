
//
//  ButtonSlot.swift
//  Game1
//
//  Created by Emil Axelsson on 21/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class ButtonSlot : SKNode {
    
    private var button : ContainerButtonNode?
    private var slot : SKSpriteNode?
    
    private var throwSelected = false
    private var contentsHidden = false
    
    override init() {

        let bSlot = SKSpriteNode(imageNamed: "ButtonSlot");
        self.slot = bSlot;
        
        
        super.init()
        
        let size : CGFloat = 80;
        let rect = CGRectMake(-size/2, -size/2, size, size)
        let radius : CGFloat = 10
        
        self.zPosition = ZLayer.ButtonSlots.toRaw()
        addChild(bSlot)


       
        updateStyle()
    }
    
    func isEmpty() -> Bool {
        return button == nil
    }

    func setButton(button: ContainerButtonNode) {
        clear()
        self.button = button
        addChild(button)
    }
    
    func clear() {
        button?.removeFromParent()
        button = nil
//        removeAllChildren()
        throwSelected = false
        updateStyle()
    }
    
    func getButton() -> ContainerButtonNode? {
        return button
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setThrowSelected(selected: Bool) {
        throwSelected = selected
        updateStyle()
    }
    
    func setContentsHidden(hidden: Bool) {
        contentsHidden = hidden
        updateStyle()
    }
    
    func updateStyle() {
        if (button == nil) {
            self.alpha = 0.4
        } else {
            self.alpha = 1.0
        }
        
        if (throwSelected) {
//            self.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
//            self.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        } else {
//            self.fillColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.2)
//            self.strokeColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0)
        }
        
        button?.hidden = contentsHidden
    }
    
}
