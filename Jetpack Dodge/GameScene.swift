//
//  GameScene.swift
//  Jetpack Dodge
//
//  Created by Pines on 7/13/17.
//  Copyright © 2017 Pines. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import AVFoundation

class GameScene: SKScene {
    
    var myShip = SKSpriteNode()
    var textureArray = [SKTexture]()
    
    var coin = SKSpriteNode()
    var coinTextureArray = [SKTexture]()

    var enemy = SKSpriteNode()
    var scoreboard = SKSpriteNode(color: SKColor.green, size: CGSize(width: 750, height:40))
    var label = SKLabelNode()
    
    var lives = 3
    var score = 0

    
    
    
    override func didMove(to view: SKView) {
        
        self.scoreboard.position = CGPoint(x: 0, y: -650)
        self.scoreboard.color = UIColor(red: 150, green: 0, blue: 0, alpha: 0.3)
                self.addChild(scoreboard)
        
        for i in (1...6)
        {
            let textureName = "ship\(i)"
            textureArray.append(SKTexture(imageNamed: textureName))
        }
        
        for i in (1...4)
        {
            let coinTextureName = "coin\(i)"
            coinTextureArray.append(SKTexture(imageNamed: coinTextureName))
        }
        
    
        if(textureArray.count > 1) {
        myShip = SKSpriteNode(imageNamed: "ship1")
        myShip.position = CGPoint(x: 0, y: -300)
        myShip.size = CGSize(width: 400,height: 400)
        self.addChild(myShip)
        }
        
        if(coinTextureArray.count > 1) {
            coin = SKSpriteNode(imageNamed: "coin1")
            coin.position = CGPoint(x: 0, y: 0)
            coin.size = CGSize(width: 200, height: 200)
            self.addChild(coin)
        }
        
        
        myShip.run(SKAction.repeatForever(
            SKAction.animate(with: textureArray,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),withKey:"Ship")
        
        coin.run(SKAction.repeatForever(
            SKAction.animate(with: coinTextureArray,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),withKey:"Coin")
        
        
        
        
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        
                self.addChild(label)
        
        
        generateEnemies()

    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            myShip.run(SKAction.moveTo(x: location.x, duration: 0.25)) // moves ship to x location of touch
            myShip.run(SKAction.moveTo(y: location.y, duration: 0.25)) // moves ship to y location of touch
            
            
            
            
            
            
        }
        
         generateEnemies()
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        enemy.isHidden = false
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            myShip.run(SKAction.moveTo(x: location.x, duration: 0.25)) // moves ship to x location of touch
            
            myShip.run(SKAction.moveTo(y: location.y, duration: 0.25)) // moves ship to y location of touch
            
            
            
            
            
        }
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // called before each frame is rendered
        self.label.text = "   lives:      \(lives)                               score:     \(score)"
        self.label.fontName = "Times New Roman"
        self.label.position = CGPoint(x : -60, y: -660)
        
                  score += 5
        
    }
    
    

    
    func generateEnemies(){
        
        
        if(self.action(forKey: "spawning") != nil){return}
        
        
        
        let timer = SKAction.wait(forDuration: 2)
        
        //let timer = SKAction.waitForDuration(10, withRange: 3)//you can use withRange to randomize duration
        
        
        let spawnNode = SKAction.run {
            
            let randomXStart = arc4random_uniform(5)
            var startPoint = CGPoint(x: 0, y: 0)
            
            if randomXStart == 0 {
                startPoint = CGPoint(x: -250, y: 800)
            } else if randomXStart == 1 {
                startPoint = CGPoint(x: 0, y: 800)
            } else if randomXStart == 2 {
                startPoint = CGPoint(x: 250, y: 800)
            } else if randomXStart == 3 {
                startPoint = CGPoint(x: -150, y: 800)
            } else if randomXStart == 4 {
                startPoint = CGPoint(x: 150, y: 800)
            }
            
            //spawn enemies inside view's bounds
            let spawnLocation = startPoint
            
            self.enemy.position = spawnLocation
            
            let randomize = Int(arc4random_uniform(500)) - 250
            
            self.coin.position = CGPoint(x: randomize, y: 800)
            
            
            self.enemy.run(SKAction.moveTo(y: self.enemy.position.y - 2000, duration: 1.5))
            self.enemy.size.width = CGFloat(arc4random_uniform(200)) + 100
            self.coin.run(SKAction.moveTo(y: self.coin.position.y - 2000, duration: 1.0))
            
        }
        
        let sequence = SKAction.sequence([timer, spawnNode])
        
        
        self.run(SKAction.repeatForever(sequence) , withKey: "spawning") // run action with key so you can remove it later 
    }
    
}

