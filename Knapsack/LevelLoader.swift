
//
//  File.swift
//  Knapsack
//
//  Created by Emil Axelsson on 09/10/14.
//  Copyright (c) 2014 Emil Axelsson. All rights reserved.
//

import SpriteKit


class LevelLoader {
    
    
    func getImage(urlToRequest: String) -> SKSpriteNode {
        let imageData = NSData(contentsOfURL: NSURL(string: urlToRequest))
        let image = UIImage(data: imageData)

        return SKSpriteNode(texture: SKTexture(image: image))
    }
    
    
    func getJSON(urlToRequest: String) -> NSData{
        return NSData(contentsOfURL: NSURL(string: urlToRequest))
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return dict
    }
    
    func parseBackgroundsJSON(json: NSArray, relativeToUrl: String) -> [SKSpriteNode] {
        var backgrounds:[SKSpriteNode] = []
        for backgroundJSON in json {
            if let data = backgroundJSON as? NSDictionary {
                if let src = data["src"] as? NSString {
                    if let offsetX = data["x"] as? NSNumber {
                        if let offsetY = data["y"] as? NSNumber {
                            var node = getImage("\(relativeToUrl)/\(src)")
                            node.anchorPoint = CGPoint(x: 0.0, y: 1.0);
                            node.zPosition = ZLayer.WorldBackground.toRaw()
                            node.setScale(CGFloat(0.5))
                            node.position.x = offsetX
                            node.position.y = offsetY
                            backgrounds.append(node)
                        }
                    }
                }

            }
        }
        return backgrounds
    }
    
    func parseForegroundsJSON(json: NSArray, relativeToUrl: String) -> [SKSpriteNode] {
        var foregrounds:[SKSpriteNode] = []
        for foregroundsJSON in json {
            if let data = foregroundsJSON as? NSDictionary {
                if let src = data["src"] as? NSString {
                    if let offsetX = data["x"] as? NSNumber {
                        if let offsetY = data["y"] as? NSNumber {
                            var node = getImage("\(relativeToUrl)/\(src)")
                            node.anchorPoint = CGPoint(x: 0.0, y: 1.0);
                            node.zPosition = ZLayer.WorldForeground.toRaw()
                            node.setScale(CGFloat(0.5))
                            node.position.x = offsetX
                            node.position.y = offsetY
                            
                            foregrounds.append(node)
                        }
                    }
                }
                
            }
        }
        return foregrounds
    }
    
    
    func parseSolidsJSON(json: NSArray) -> [SKShapeNode] {
        var solids : [SKShapeNode] = []
        for solidJSON in json {
            var points: [CGPoint] = []
            if let pointsJSON = solidJSON as? NSArray {
                for pointJSON in pointsJSON {
                    if let p = pointJSON as? NSDictionary {
                        if let xData = p["x"] as? NSNumber {
                            if let yData = p["y"] as? NSNumber {
                                let point = CGPoint(x: CGFloat(xData), y: CGFloat(yData))
                                points.append(point)
                            }
                        }
                    }
                }
            }
            if (points.count > 0) {
                let path = createPathFromPoints(points)
                let shapeNode = createWallShape(path)
                solids.append(shapeNode)
            }
        }
        return solids
    }
    
    func parseDangersJSON(json: NSArray) -> [SKShapeNode] {
        var dangers : [SKShapeNode] = []
        for dangerJSON in json {
            var points: [CGPoint] = []
            if let pointsJSON = dangerJSON as? NSArray {
                for pointJSON in pointsJSON {
                    if let p = pointJSON as? NSDictionary {
                        if let xData = p["x"] as? NSNumber {
                            if let yData = p["y"] as? NSNumber {
                                let point = CGPoint(x: CGFloat(xData), y: CGFloat(yData))
                                points.append(point)
                            }
                        }
                    }
                }
            }
            if (points.count > 0) {
                let path = createPathFromPoints(points)
                let shapeNode = createDangerShape(path)
                dangers.append(shapeNode)
            }
        }
        return dangers
    }
    
    
    func createButtonFromSpec(type: String, x: CGFloat, y:CGFloat, mainCharacter:MainCharacter) -> Button? {
        println(x)
        println(y)
        
        let bb = ButtonBuilder()
        
        var containerNode = ContainerButtonNode()
        var worldNode = WorldButtonNode()
        worldNode.position = CGPoint(x: x, y: y);
        
        var guts: ButtonGuts?
        switch (type) {
            case "left":
                guts = LeftButton(mainCharacter: mainCharacter)
                break
            case "right":
                guts = RightButton(mainCharacter: mainCharacter)
                break
            case "jump":
                guts = JumpButton(mainCharacter: mainCharacter)
                break
            case "punch":
                guts = PunchButton(mainCharacter: mainCharacter)
                break
            default:
                break
        }
        
        if let g = guts {
            containerNode.setContents(g.getContainerNodeContents());
            worldNode.setContents(g.getWorldNodeContents());
        
            var button = Button(guts: g, worldNode: worldNode, containerNode: containerNode)
            return button
        } else {
            return nil
        }
    }
    
    func parseButtonsJSON(json: NSArray, mainCharacter: MainCharacter) -> [Button] {
        var buttons: [Button] = []
        for buttonJSON in json {
            if let b = buttonJSON as? NSDictionary {
                if let typeData = b["button"] as? NSString {
                    if let xData = b["x"] as? NSNumber {
                        if let yData = b["y"] as? NSNumber {
                            if let button = createButtonFromSpec(String(typeData), x: CGFloat(xData), y: CGFloat(yData), mainCharacter: mainCharacter) {
                                buttons.append(button)
                            }
                        }
                    }
                }
            }
        }
        return buttons
    }

    func parseMainCharacterJSON(json: NSDictionary) -> MainCharacter {
        let mc = MainCharacter()
        if let xData = json["x"] as? NSNumber {
            if let yData = json["y"] as? NSNumber {
                mc.setPosition(CGPoint(x: CGFloat(xData), y: CGFloat(yData)))
            }
        }
        return mc
    }
    
    func parseGoalJSON(json: NSDictionary) -> Goal {
        let goal = Goal()
        if let xData = json["x"] as? NSNumber {
            if let yData = json["y"] as? NSNumber {
                goal.position = CGPoint(x: CGFloat(xData), y: CGFloat(yData))
            }
        }
        return goal
    }
    
    func parseSpawnButtonsJSON(json: NSArray, mainCharacter: MainCharacter) -> [Button] {
        var buttons: [Button] = []
        for buttonJSON in json {
            if let typeData = buttonJSON as? NSString {
                if let button = createButtonFromSpec(String(typeData), x: 0, y: 0, mainCharacter: mainCharacter) {
                    buttons.append(button)
                }
            }
        }
        return buttons
    }
    


    func loadLevel(url: String) -> Level {
        let json = getJSON("\(url)/level.json")
        let data = parseJSON(json)
        
        var spawnButtons:[Button] = []
        var mainCharacter = MainCharacter()
        if let spawnJSON = data["spawn"] as? NSDictionary {
            mainCharacter = parseMainCharacterJSON(spawnJSON)
            if let buttonsJSON = spawnJSON["buttons"] as? NSArray {
                spawnButtons = parseSpawnButtonsJSON(buttonsJSON, mainCharacter: mainCharacter)
            }
        }
        
        var buttons:[Button] = [];
        if let buttonsJSON = data["buttons"] as? NSArray {
            buttons = parseButtonsJSON(buttonsJSON, mainCharacter: mainCharacter)
        }
        
        var solids:[SKShapeNode] = []
        if let solidsJSON = data["solids"] as? NSArray {
            solids = parseSolidsJSON(solidsJSON)
        }

        var dangers:[SKShapeNode] = []
        if let dangersJSON = data["dangers"] as? NSArray {
            dangers = parseDangersJSON(dangersJSON)
        }
        

        
        
        let world = SKNode();
        
        var backgrounds:[SKSpriteNode] = []
        if let backgroundsJSON = data["backgrounds"] as? NSArray {
                println("print line!")
            backgrounds = parseBackgroundsJSON(backgroundsJSON, relativeToUrl: url);
            for background in backgrounds {

                world.addChild(background)
            }
        }
        
        
        
        var foregrounds:[SKSpriteNode] = []
        if let foregroundsJSON = data["foregrounds"] as? NSArray {
                            println("fg line!")
            foregrounds = parseForegroundsJSON(foregroundsJSON, relativeToUrl: url);
            for foreground in foregrounds {

                world.addChild(foreground)
            }
        }
        
        
        if let goalJSON = data["goal"] as? NSDictionary {
            let goal = parseGoalJSON(goalJSON)
            world.addChild(goal);
        }
        
        
        for s in solids {
            world.addChild(s)
        }
        for d in dangers {
            world.addChild(d)
        }
        for b in buttons {
            if let c = b.getWorldNode() {
                world.addChild(c)
            }
        }
        
        return LoadedLevel(mainCharacter: mainCharacter, world: world, spawnButtons: spawnButtons)
        
    }

    
    
}