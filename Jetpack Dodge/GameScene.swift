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

struct ColliderType {
    static let Player: UInt32 = 1
    static let Enemy: UInt32 = 2
    static let Coin: UInt32 = 3
}

let spaceShipTexture = SKTexture(image: #imageLiteral(resourceName: "ship6"))
let coinTexture = SKTexture(image: #imageLiteral(resourceName: "coin1"))
let enemyTexture = SKTexture(image: #imageLiteral(resourceName: "rock1"))
var timer = SKAction.wait(forDuration: 4)

class GameScene: SKScene {
    
    var myShip = SKSpriteNode()
    var textureArray = [SKTexture]()
    
    var coin = SKSpriteNode()
    var coinTextureArray = [SKTexture]()
    
    var enemy = SKSpriteNode()
    var rockTextureArray = [SKTexture]()
    
    var scoreboard = SKSpriteNode(color: SKColor.green, size: CGSize(width: 750, height:40))
    
    var label = SKLabelNode()
    
    var imageView = SKSpriteNode()
    
    var lives = 3
    var score = 0
    
    
    override func didMove(to view: SKView) {
        
        backgroundPic.zPosition = -1
        backgroundPic.position = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
        backgroundPic.size = CGSize(width: 5000, height: 5000)
        addChild(backgroundPic)
        
        self.scoreboard.position = CGPoint(x: 0, y: -650)
        self.scoreboard.color = UIColor(red: 150, green: 0, blue: 0, alpha: 0.3)
        
        for i in (1...3)
        {
            let textureName = "ship\(i)"
            textureArray.append(SKTexture(imageNamed: textureName))
        }
        
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
        
        for i in (1...4){
            let rockTextureName = "rock\(i)"
            rockTextureArray.append(SKTexture(imageNamed: rockTextureName))
        }
        
        
        if(textureArray.count > 1) {
        myShip = SKSpriteNode(imageNamed: "ship1")
        myShip.position = CGPoint(x: 0, y: -300)
        myShip.size = CGSize(width: 400,height: 400)
        }
        
        if(coinTextureArray.count > 1) {
            coin = SKSpriteNode(imageNamed: "coin1")
            coin.position = CGPoint(x: 0, y: 0)
            coin.size = CGSize(width: 200, height: 200)
        }
        
        if(rockTextureArray.count > 1)
        {
        enemy = SKSpriteNode(imageNamed: "rock1")
        enemy.position = CGPoint(x: 0, y: 0)
            enemy.size = CGSize(width: 800, height:500)
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
        
        enemy.run(SKAction.repeatForever(
            SKAction.animate(with: rockTextureArray,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),withKey:"Rock")
        generateEnemies()
        
        self.addChild(scoreboard)
        self.addChild(myShip)
        self.addChild(coin)
        self.addChild(enemy)
        self.addChild(label)
        
    }

    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        for touch in touches {
            let location = touch.location(in: self)
            
            myShip.run(SKAction.moveTo(x: location.x, duration: 0.25)) // moves ship to x location of touch
            myShip.run(SKAction.moveTo(y: location.y, duration: 0.25)) // moves ship to y location of touch
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
            self.enemy.size.width = CGFloat(arc4random_uniform(200)) + 400
            self.enemy.size.height = CGFloat(arc4random_uniform(200)) + 400
            
            self.coin.run(SKAction.moveTo(y: self.coin.position.y - 2000, duration: 1.0))
            
        }
        
        let sequence = SKAction.sequence([timer, spawnNode])
        
        
        self.run(SKAction.repeatForever(sequence) , withKey: "spawning") // run action with key so you can remove it later 
    }
    
    
    
    func didBegin() {
        if(lives == 0)
        {
            
        }
    }
    
}

