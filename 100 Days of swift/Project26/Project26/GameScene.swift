//
//  GameScene.swift
//  Project26
//
//  Created by Manuel Teixeira on 13/07/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

enum CollisionTypes: UInt32 {
    case player = 1
    case wall = 2
    case star = 4
    case vortex = 8
    case finish = 16
    case teleport = 32
}

class GameScene: SKScene, SKPhysicsContactDelegate {

    var player: SKSpriteNode!
    var lastTouchPosition: CGPoint?
    
    var motionManager: CMMotionManager?
    var isGameOver = false
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var currentLevel = 1
    var teleportNodes = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
        startGame()
        loadLevel(withName: "level1")
        createPlayer()
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        motionManager = CMMotionManager()
        motionManager?.startAccelerometerUpdates()
    }
    
    func startGame() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.zPosition = 2
        addChild(scoreLabel)
    }
    
    func loadLevel(withName levelName: String) {
        guard let levelURL = Bundle.main.url(forResource: levelName, withExtension: "txt") else {
            fatalError("Could not find \(levelName).txt in the app bundle.")
        }
        
        guard let levelString = try? String(contentsOf: levelURL) else {
            fatalError("Could not find \(levelName).txt in the app bundle.")
        }
        
        let lines = levelString.components(separatedBy: "\n")
        
        for (row, line) in lines.reversed().enumerated() {
            for (column, letter) in line.enumerated() {
                let position = CGPoint(x: (64 * column) + 32, y: (64 * row) + 32)
                
                createNodeFrom(letter: letter, position: position)
            }
        }
    }
    
    func createNodeFrom(letter: String.Element, position: CGPoint) {
        switch letter {
        case "x":
            let node = SKSpriteNode(imageNamed: "block")
            node.position = position
            
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            node.physicsBody?.isDynamic = false
            
            addChild(node)
        case "v":
            let node = SKSpriteNode(imageNamed: "vortex")
            node.name = "vortex"
            node.position = position
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: .pi, duration: 1)))
            
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            
            addChild(node)
        case "s":
            let node = SKSpriteNode(imageNamed: "star")
            node.name = "star"
            node.position = position
            
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            
            addChild(node)
        case "f":
            let node = SKSpriteNode(imageNamed: "finish")
            node.name = "finish"
            node.position = position
            
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            
            addChild(node)
        case "t":
            let node = SKSpriteNode(imageNamed: "star")
            node.color = .red
            node.colorBlendFactor = 1
            node.name = "teleport"
            node.position = position
            teleportNodes.append(node)
            
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            node.physicsBody?.collisionBitMask = 0
            
            addChild(node)
        case " ":
            return
        default:
            fatalError("Unknown level letter: \(letter)")
        }
    }
    
    func createPlayer(position: CGPoint = CGPoint(x: 96, y: 672)) {
        player = SKSpriteNode(imageNamed: "player")
        player.position = position
        player.zPosition = 1
        
        player.physicsBody = SKPhysicsBody(circleOfRadius: player.size.width / 2)
        player.physicsBody?.allowsRotation = false
        player.physicsBody?.linearDamping = 0.5
        
        player.physicsBody?.categoryBitMask = CollisionTypes.player.rawValue
        player.physicsBody?.contactTestBitMask = CollisionTypes.star.rawValue | CollisionTypes.vortex.rawValue | CollisionTypes.finish.rawValue | CollisionTypes.teleport.rawValue
        player.physicsBody?.collisionBitMask = CollisionTypes.wall.rawValue
        
        addChild(player)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        let location = touch.location(in: self)
        lastTouchPosition = location
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        lastTouchPosition = nil
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard !isGameOver else { return }
        
        #if targetEnvironment(simulator)
        if let lastTouchPosition = lastTouchPosition {
            let diff = CGPoint(x: lastTouchPosition.x - player.position.x, y: lastTouchPosition.y - player.position.y)
            physicsWorld.gravity = CGVector(dx: diff.x / 100, dy: diff.y / 100)
        }
        #else
        if let accelerometerData = motionManager?.accelerometerData {
            physicsWorld.gravity = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
        }
        #endif
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA == player {
            playerCollided(with: nodeB)
        } else if nodeB == player {
            playerCollided(with: nodeA)
        }
    }
    
    func playerCollided(with node: SKNode) {
        if node.name == "vortex" {
            player.physicsBody?.isDynamic = false
            isGameOver = true
            score -= 1
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.0001, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer()
                self?.isGameOver = false
            }
        } else if node.name == "star" {
            node.removeFromParent()
            score += 1
        } else if node.name == "finish" {
            score = 0
            player.physicsBody?.isDynamic = false
            isGameOver = true
            
            removeAllChildren()
            
            currentLevel += 1
            
            startGame()
            loadLevel(withName: "level\(currentLevel)")
            createPlayer()

            player.physicsBody?.isDynamic = true
            isGameOver = false
        } else if node.name == "teleport" {
            player.physicsBody?.isDynamic = false

            var newPosition = CGPoint(x: 0, y: 0)
            for teleportNode in teleportNodes {
                if node.position != teleportNode.position {
                    newPosition = CGPoint(x: teleportNode.position.x + 64, y: teleportNode.position.y)
                }
            }
            
            let move = SKAction.move(to: node.position, duration: 0.25)
            let scale = SKAction.scale(to: 0.1, duration: 0.25)
            let remove = SKAction.removeFromParent()
            
            let sequence = SKAction.sequence([move, scale, remove])
            
            player.run(sequence) { [weak self] in
                self?.createPlayer(position: newPosition)
                let move = SKAction.move(to: newPosition, duration: 0.25)
                let scaleUp = SKAction.scale(to: 1, duration: 0.25)
                let sequence = SKAction.sequence([move, scaleUp])
                self?.player.run(sequence)
            }
        }
    }
}
