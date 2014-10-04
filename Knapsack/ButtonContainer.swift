//
//  File.swift
//  Game1
//
//  Created by Emil Axelsson on 18/09/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit

class ButtonContainer: SKNode, Thrower {
    
    
    enum SlotOrigin {
        case BottomLeft
        case BottomRight
    }

    enum SlotAlignment {
        case Horizontal
        case Vertical
    }
    
    var bottomLeftSlot: ButtonSlot?
    var bottomRightSlot: ButtonSlot?

    var bottomLeftVerticalSlots: [ButtonSlot] = []
    var bottomLeftHorizontalSlots: [ButtonSlot] = []

    var bottomRightVerticalSlots: [ButtonSlot] = []
    var bottomRightHorizontalSlots: [ButtonSlot] = []
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    var margin: CGFloat  = 10
    var slotWidth: CGFloat = 64
    var slotHeight: CGFloat = 64
    
    var nextThrowSlot: ButtonSlot?
    var throwSlot: ThrowSlot?
    
    private var throwTouch: UITouch?
    
    private var mainCharacter: MainCharacter
    
    private var placeholder = SKShapeNode(rectOfSize: CGSize(width: 0, height: 0))
    
    private var state: ButtonContainerState
    
    func setState(state: ButtonContainerState) {
        self.state = state
    }
    
    init (mainCharacter: MainCharacter) {
        self.mainCharacter = mainCharacter
        self.state = DefaultButtonContainerState()
        super.init()
        self.userInteractionEnabled = true
        self.addChild(placeholder)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectThrowSlot(slot: ButtonSlot) {
        if let ts = nextThrowSlot {
            ts.setThrowSelected(false)
        }
        nextThrowSlot = getNextFilledSlot(slot)
        if let ts = nextThrowSlot {
            ts.setThrowSelected(true)
        }
    }
    
    func deselectThrowSlot() {
        if let ts = nextThrowSlot {
            ts.setThrowSelected(false)
        }
        nextThrowSlot = nil
    }
    
    func getThrowSlotButton() -> Button? {
        return nextThrowSlot?.getButton()?.button
    }
    
    func getNextFilledSlot(current: ButtonSlot?) -> ButtonSlot? {
        var foundCurrent = false
        
        if (current === nil) {
            foundCurrent = true
        }
        
        for (var i = bottomLeftVerticalSlots.count - 1; i >= 0; i--) {
            if (current === bottomLeftVerticalSlots[i]) {
                foundCurrent = true
            }
            if (foundCurrent && !bottomLeftVerticalSlots[i].isEmpty()) {
                return bottomLeftVerticalSlots[i];
            }
        }
        if current === bottomLeftSlot {
            foundCurrent = true
        }
        
        if (foundCurrent && bottomLeftSlot !== nil && !bottomLeftSlot!.isEmpty()) {
            return bottomLeftSlot
        }

        for (var i = 0; i < bottomLeftHorizontalSlots.count; i++) {
            if (current === bottomLeftHorizontalSlots[i]) {
                foundCurrent = true
            }
            if (foundCurrent && !bottomLeftHorizontalSlots[i].isEmpty()) {
                return bottomLeftHorizontalSlots[i];
            }
        }
        
        for (var i = bottomRightHorizontalSlots.count - 1; i >= 0; i--) {
            if (current === bottomRightHorizontalSlots[i]) {
                foundCurrent = true
            }
            if (foundCurrent && !bottomRightHorizontalSlots[i].isEmpty()) {
                return bottomRightHorizontalSlots[i];
            }
        }
        
        if current === bottomRightSlot {
            foundCurrent = true
        }
        
        if (foundCurrent && bottomRightSlot !== nil && !bottomRightSlot!.isEmpty()) {
            return bottomRightSlot
        }
        
        for (var i = 0; i < bottomRightVerticalSlots.count; i++) {
            if (current === bottomRightVerticalSlots[i]) {
                foundCurrent = true
            }
            if (foundCurrent && !bottomRightVerticalSlots[i].isEmpty()) {
                return bottomRightVerticalSlots[i];
            }
        }
        if (current === nil) {
            return nil
        } else {
            return getNextFilledSlot(nil)
        }
    }
    
    func setSize(size: CGSize) {
        width = size.width
        height = size.height
        updateSlotPositions()
        placeholder.removeFromParent()
        placeholder = SKShapeNode(rectOfSize: CGSize(width: width, height: height))
        placeholder.position.x = width/2
        placeholder.position.y = height/2
        placeholder.hidden = true
        self.addChild(placeholder)
    }
    
    func forEachButtonSlot(f : (ButtonSlot) -> ()) {
        if let slot = bottomLeftSlot {
            f(slot)
        }
        if let slot = bottomRightSlot {
            f(slot)
        }
        for slot in bottomLeftHorizontalSlots {
            f(slot)
        }
        for slot in bottomRightHorizontalSlots {
            f(slot)
        }
        for slot in bottomLeftVerticalSlots {
            f(slot)
        }
        for slot in bottomRightVerticalSlots {
            f(slot)
        }
    }
    
    func updateSlotPositions() {
        if let slot = bottomLeftSlot {
            slot.position = bottomLeftHorizontalPosition(0)
        }
        if let slot = bottomRightSlot {
            slot.position = bottomRightHorizontalPosition(0)
        }
        for (i, slot) in enumerate(bottomLeftHorizontalSlots) {
            slot.position = bottomLeftHorizontalPosition(i + 1)
        }
        for (i, slot) in enumerate(bottomRightHorizontalSlots) {
            slot.position = bottomRightHorizontalPosition(i + 1)
        }
        for (i, slot) in enumerate(bottomLeftVerticalSlots) {
            slot.position = bottomLeftVerticalPosition(i + 1)
        }
        for (i, slot) in enumerate(bottomRightVerticalSlots) {
            slot.position = bottomRightVerticalPosition(i + 1)
        }
    }
    
    func setBottomLeftSlot(buttonSlot: ButtonSlot) -> Bool {
        if (bottomLeftSlot === nil) {
            bottomLeftSlot = buttonSlot;
            addChild(buttonSlot)
            buttonSlot.position = bottomLeftHorizontalPosition(0)
            return true
        } else {
            return false
        }
    }
    
    func setBottomRightSlot(buttonSlot: ButtonSlot) -> Bool {
        if (bottomRightSlot === nil) {
            bottomRightSlot = buttonSlot;
            addChild(buttonSlot)
            buttonSlot.position = bottomRightHorizontalPosition(0)
            return true
        } else {
            return false
        }
    }
    
    func appendBottomLeftHorizontalSlots(buttonSlot: ButtonSlot) {
        bottomLeftHorizontalSlots.append(buttonSlot)
        addChild(buttonSlot)
        buttonSlot.position = bottomLeftHorizontalPosition(bottomLeftHorizontalSlots.count)
    }

    func appendBottomRightHorizontalSlots(buttonSlot: ButtonSlot) {
        bottomRightHorizontalSlots.append(buttonSlot)
        addChild(buttonSlot)
        buttonSlot.position = bottomRightHorizontalPosition(bottomRightHorizontalSlots.count)
    }

    func appendBottomLeftVerticalSlots(buttonSlot: ButtonSlot) {
        bottomLeftVerticalSlots.append(buttonSlot)
        addChild(buttonSlot)
        buttonSlot.position = bottomLeftVerticalPosition(bottomLeftVerticalSlots.count)
    }
    
    func appendBottomRightVerticalSlots(buttonSlot: ButtonSlot) {
        bottomRightVerticalSlots.append(buttonSlot)
        addChild(buttonSlot)
        buttonSlot.position = bottomRightVerticalPosition(bottomRightVerticalSlots.count)
    }
    
    func bottomLeftHorizontalPosition(index: Int) -> CGPoint {
        return CGPoint(
            x: margin + slotWidth / 2.0 + CGFloat(index)*(slotWidth + margin),
            y: slotHeight / 2.0 + margin
        );
    }

    func bottomRightHorizontalPosition(index: Int) -> CGPoint {
        return CGPoint(
            x: width - (margin + slotWidth / 2.0 + CGFloat(index)*(slotWidth + margin)),
            y: slotHeight / 2.0 + margin
        );
    }
    
    func bottomLeftVerticalPosition(index: Int) -> CGPoint {
        return CGPoint(
            x: slotWidth / 2.0 + margin,
            y: margin + slotHeight / 2.0 + CGFloat(index)*(slotHeight + margin)
        );
    }
    
    func bottomRightVerticalPosition(index: Int) -> CGPoint {
        return CGPoint(
            x: slotWidth / 2.0 + margin,
            y: height - (margin + slotHeight / 2.0 + CGFloat(index)*(slotHeight + margin))
        );
    }
    
    
    func addSlot(buttonSlot: ButtonSlot, origin: SlotOrigin, alignment: SlotAlignment) {
        switch (origin) {
        case SlotOrigin.BottomLeft:
            if (!setBottomLeftSlot(buttonSlot)) {
                switch (alignment) {
                case SlotAlignment.Horizontal:
                    appendBottomLeftHorizontalSlots(buttonSlot)
                    break
                case SlotAlignment.Vertical:
                    appendBottomLeftVerticalSlots(buttonSlot);
                    break
                }
            }
            break
        case SlotOrigin.BottomRight:
            if (!setBottomRightSlot(buttonSlot)) {
                switch (alignment) {
                case SlotAlignment.Horizontal:
                    appendBottomRightHorizontalSlots(buttonSlot);
                    break
                case SlotAlignment.Vertical:
                    appendBottomRightVerticalSlots(buttonSlot);
                    break
                }
            }
            break
        }
    }
    
    func clearSlot(slot: ButtonSlot) {
        slot.clear()
        if (self.nextThrowSlot === slot) {
            if let s = self.getNextFilledSlot(self.nextThrowSlot) {
                self.selectThrowSlot(s)
            } else {
                self.deselectThrowSlot()
            }
        }
    }
    
    func removeButton(b : Button) -> Bool {
        var foundButton = false;
        forEachButtonSlot { (slot) -> () in
            if b.getContainerNode() === slot.getButton() {
                println(" clearing button: \(slot.getButton())")
                self.clearSlot(slot)
                foundButton = true
            }
        }
        return foundButton
    }
    
    func hasButton(b: Button) -> Bool {
        var foundButton = false;
        forEachButtonSlot { (slot) -> () in
            if b.getContainerNode() === slot.getButton() {
                foundButton = true
            }
        }
        return foundButton
    }
    
    func addButton(button : Button) -> Bool{
        if (self.hasButton(button)) {
            return false
        }
        
        if let buttonContainerNode = button.getContainerNode() {
            if let bl = bottomLeftSlot {
                if bl.isEmpty() {
                    bl.setButton(buttonContainerNode)
                    selectThrowSlot(bl)
                    return true
                }
            }
            if let br = bottomRightSlot {
                if br.isEmpty() {
                    br.setButton(buttonContainerNode)
                    selectThrowSlot(br)
                    return true
                }
            }

            var bs: ButtonSlot?
            for (var i = 0; true; i++) {
                if (bottomLeftHorizontalSlots.count > i && bottomLeftHorizontalSlots[i].isEmpty()) {
                    bs = bottomLeftHorizontalSlots[i]
                } else if (bottomRightHorizontalSlots.count > i && bottomRightHorizontalSlots[i].isEmpty()) {
                    bs = bottomRightHorizontalSlots[i]
                } else if (bottomLeftVerticalSlots.count > i && bottomLeftVerticalSlots[i].isEmpty()) {
                    bs = bottomLeftVerticalSlots[i]
                } else if (bottomRightVerticalSlots.count > i && bottomRightVerticalSlots[i].isEmpty()) {
                    bs = bottomRightVerticalSlots[i]
                } else {
                    return false
                }
                
                if let s = bs {
                    s.setButton(buttonContainerNode);
                    selectThrowSlot(s)
                    return true;
                }
            }
        }
        return false
    }
    
    func update(currentTime: CFTimeInterval) {
        forEachButtonSlot({(bs : ButtonSlot) -> () in
            bs.getButton()?.button?.update(currentTime)
            return
        })
    }
    
    func press(bs: ButtonSlot?, touchEvent: UITouch) {
        state.press(bs, touchEvent: touchEvent, position: touchEvent.locationInNode(self))
    }
    
    func release(bs: ButtonSlot?, touchEvent: UITouch) {
        state.release(bs, touchEvent: touchEvent, position: touchEvent.locationInNode(self))
    }
    
    func drag(bs: ButtonSlot?, touchEvent: UITouch) {
        state.drag(bs, touchEvent: touchEvent, position: touchEvent.locationInNode(self))
    }
    
    func enterThrowMode(touch: UITouch) -> Bool {
        setState(ThrowButtonContainerState(container: self))
        if let ts = throwSlot {
            ts.removeFromParent()
        }
        let ts = ThrowSlot()
        addChild(ts)
        
        throwSlot = ts
        throwTouch = touch
        updateThrowMode()
        
        if let nts = nextThrowSlot {
            nts.setContentsHidden(true)
        }
        
        return true
    }
    
    func leaveThrowMode() -> Bool {
        setState(DefaultButtonContainerState())
        if let ts = throwSlot {
            ts.removeFromParent()
        }
        throwSlot = nil
        mainCharacter.setElastic(nil)
        
        forEachButtonSlot { (slot) -> () in
            slot.setContentsHidden(false)
        }
        
        return true
    }
    
    func throwButton() -> Bool {
        if let b = getThrowSlotButton() {
            if let wn = b.getWorldNode() {
                if let tt = throwTouch {
                    let pos = tt.locationInNode(mainCharacter.getCenterNode())
                    mainCharacter.throwButton(wn, elasticOffset: CGVector(dx: pos.x, dy: pos.y))
                    removeButton(b)
                    return true
                }
            }
        }
        return false
    }
    
    func updateThrowMode() {
        if let ts = throwSlot {
            if let tt = throwTouch {
                
                ts.position = tt.locationInNode(self)
                
                let pos = tt.locationInNode(mainCharacter.getCenterNode())
                mainCharacter.setElastic(CGVector(dx: pos.x, dy: pos.y))
            }
        }
    }
    
    func hasEnoughOffset() -> Bool {
        //return sqrt(offset.dx * offset.dx + offset.dy + offset.dy) > 100
        return true
    }
    
    
   override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    for touch in touches {
        if let t = touch as? UITouch {
            var foundSlot: ButtonSlot? = nil;
            forEachButtonSlot { (bs) -> () in
                let location = t.locationInNode(bs)
                let slotFrame = bs.frame.rectByOffsetting(dx: -bs.position.x, dy: -bs.position.y)
                if (slotFrame.contains(location)) {
                    foundSlot = bs
                }
            }
            self.press(foundSlot, touchEvent: t);
        }
    }

    }
    

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            if let t = touch as? UITouch {
                var foundSlot: ButtonSlot? = nil;
                forEachButtonSlot { (bs) -> () in
                    let location = t.locationInNode(bs)
                    let slotFrame = bs.frame.rectByOffsetting(dx: -bs.position.x, dy: -bs.position.y)
                    if (slotFrame.contains(location)) {
                        foundSlot = bs
                    }
                }
                self.drag(foundSlot, touchEvent: t);
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch in touches {
            if let t = touch as? UITouch {
                var foundSlot: ButtonSlot? = nil;
                forEachButtonSlot { (bs) -> () in
                    let location = t.locationInNode(bs)
                    let slotFrame = bs.frame.rectByOffsetting(dx: -bs.position.x, dy: -bs.position.y)
                    if (slotFrame.contains(location)) {
                        foundSlot = bs
                    }
                }
                self.release(foundSlot, touchEvent: t);                
            }
        }
    }
    
    override func touchesCancelled(touches: NSSet, withEvent event: UIEvent) {
        touchesEnded(touches, withEvent: event)
    }

    
}
