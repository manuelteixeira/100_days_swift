//
//  GameScene.swift
//  Projects 16-18
//
//  Created by Manuel Teixeira on 10/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var road: SKSpriteNode!
    var titleLabel: SKLabelNode!
    var scoreLabel: SKLabelNode!
    var reloadLabel: SKLabelNode!
    var bulletLabel: SKLabelNode!
    var gameOverLabel: SKLabelNode!
    
    var gamerTimer: Timer?
    var countdown: Timer?
    var maxGameDuration = 60
    var isGameOver = false
    var bullets = 6 {
        didSet {
            bulletLabel.text = "Bullets left: \(bullets)"
        }
    }
    var cars = ["citroen_green", "citroen_purple"]
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        road = SKSpriteNode(imageNamed: "road")
        road.position = CGPoint(x: 0, y: 384)
        road.zPosition = -1
        addChild(road)
        
        titleLabel = SKLabelNode()
        titleLabel.text = "Hit the purple Citroen's"
        titleLabel.fontSize = 24
        titleLabel.horizontalAlignmentMode = .center
        titleLabel.position = CGPoint(x: 512, y: 730)
        addChild(titleLabel)
        
        reloadLabel = SKLabelNode()
        reloadLabel.text = "Reload"
        reloadLabel.name = "reload"
        reloadLabel.fontSize = 48
        reloadLabel.position = CGPoint(x: 950, y: 16)
        addChild(reloadLabel)
        
        bulletLabel = SKLabelNode()
        bulletLabel.fontSize = 48
        bulletLabel.position = CGPoint(x: 870, y: 720)
        addChild(bulletLabel)
        
        scoreLabel = SKLabelNode()
        scoreLabel.fontSize = 48
        scoreLabel.position = CGPoint(x: 100, y: 16)
        addChild(scoreLabel)
        
        gameOverLabel = SKLabelNode(fontNamed: "Helvetica Neue Bold")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 100
        gameOverLabel.position = CGPoint(x: 512, y: 500)
        gameOverLabel.zPosition = 1
        gameOverLabel.isHidden = true
        addChild(gameOverLabel)
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        score = 0
        bullets = 6
        gamerTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(createCar), userInfo: nil, repeats: true)
        
        countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(decreaseTimer), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            if let nodeName = node.name {
                if cars.contains(nodeName) {
                    guard bullets > 0 else { return }

                    let carColor = nodeName.split(separator: "_")[1]
                    if carColor == "purple" {
                        score += 1
                    } else {
                        score -= 1
                    }
                    
                    bullets -= 1
                    node.removeFromParent()
                } else if nodeName == "reload" {
                    bullets = 6
                }
            }
        }
    }
    
    @objc func createCar() {
        guard let car = cars.randomElement() else { return }
        
        let sprite = SKSpriteNode(imageNamed: car)
        let positionY = Int.random(in: 100...600)
        sprite.position = CGPoint(x: 0, y: positionY)
        let size = Double.random(in: -0.9...0.9)
        let dScaleX = sprite.xScale * CGFloat(size)
        sprite.xScale += dScaleX
        sprite.name = car
        sprite.physicsBody = SKPhysicsBody(rectangleOf: sprite.size)
        let speed = Int.random(in: 500...2000)
        sprite.physicsBody?.velocity = CGVector(dx: speed, dy: 0)
        sprite.physicsBody?.angularVelocity = 0
        addChild(sprite)
    }
    
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x > 1024 {
                node.removeFromParent()
            }
        }
    }
    
    @objc func decreaseTimer() {
        maxGameDuration -= 1
        print(maxGameDuration)
        
        if maxGameDuration == 0 {
            gameOverLabel.isHidden = false
            countdown?.invalidate()
            gamerTimer?.invalidate()
        }
    }
}
