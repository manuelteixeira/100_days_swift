# Day 79 - Project 23, part three

- Challenge

    1. Try removing the magic numbers in the **`createEnemy()`** method. Instead, define them as constant properties of your class, giving them useful names.

        ```swift
        let BOMB_TYPE = 0
        let PENGUIN_TYPE = 1
        let MAX_LEFT_SCREEN = 64
        let MAX_RIGHT_SCREEN = 960
        let MAX_TOP_SCREEN = -128
        let MIN_ANGULAR_VELOCITY: CGFloat = -3
        let MAX_ANGULAR_VELOCITY: CGFloat = 3
        let LEFT_EDGE_SCREEN: CGFloat = 256
        let MIDDLE_SCREEN: CGFloat = 512
        let RIGHT_EDGE_SCREEN: CGFloat = 768
        let MIN_SPEED = 3
        let MED_SPEED = 5
        let MAX_SPEED = 8
        let TOP_SPEED = 15
        let MIN_Y_SPEED = 24
        let MAX_Y_SPEDD = 32
        let PHYSICS_BODY_RADIUS: CGFloat = 64
        let PHYSICS_SPEED_CONSTANT = 40
        ```

        ```swift
        func createEnemy(forceBomb: ForceBomb = .random) {
            let enemy: SKSpriteNode
            
            var enemyType = Int.random(in: 0...6)
            
            if forceBomb == .never {
                enemyType = PENGUIN_TYPE
            } else if forceBomb == .always {
                enemyType = BOMB_TYPE
            }
            
            if enemyType == BOMB_TYPE {
                enemy = SKSpriteNode()
                enemy.zPosition = 1
                enemy.name = "bombContainer"
                
                let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
                bombImage.name = "bomb"
                enemy.addChild(bombImage)
                
                if bombSoundEffect != nil {
                    bombSoundEffect?.stop()
                    bombSoundEffect = nil
                }
                
                if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                    if let sound = try? AVAudioPlayer(contentsOf: path) {
                        bombSoundEffect = sound
                        sound.play()
                    }
                }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                    emitter.position = CGPoint(x: 76, y: 64)
                    enemy.addChild(emitter)
                }
            } else {
                enemy = SKSpriteNode(imageNamed: "penguin")
                run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
                enemy.name = "enemy"
            }
            
            let randomPosition = CGPoint(x: Int.random(in: MAX_LEFT_SCREEN...MAX_RIGHT_SCREEN), y: MAX_TOP_SCREEN)
            enemy.position = randomPosition
            
            let randomAngularVelocity = CGFloat.random(in: MIN_ANGULAR_VELOCITY...MAX_ANGULAR_VELOCITY)
            let randomXVelocity: Int
            
            if randomPosition.x < LEFT_EDGE_SCREEN {
                randomXVelocity = Int.random(in: MED_SPEED...MAX_SPEED)
            } else if randomPosition.x < MIDDLE_SCREEN {
                randomXVelocity = Int.random(in: MIN_SPEED...MED_SPEED)
            } else if randomPosition.x < RIGHT_EDGE_SCREEN {
                randomXVelocity = -Int.random(in: MIN_SPEED...MED_SPEED)
            } else {
                randomXVelocity = -Int.random(in: MAX_SPEED...TOP_SPEED)
            }
            
            let randomYVelocity = Int.random(in: MIN_Y_SPEED...MAX_Y_SPEDD)
            
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: PHYSICS_BODY_RADIUS)
            enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * PHYSICS_SPEED_CONSTANT, dy: randomYVelocity * PHYSICS_SPEED_CONSTANT)
            enemy.physicsBody?.angularVelocity = randomAngularVelocity
            enemy.physicsBody?.collisionBitMask = 0
            
            addChild(enemy)
            activeEnemies.append(enemy)
        }
        ```

    1. Create a new, fast-moving type of enemy that awards the player bonus points if they hit it.

        ```swift
        func createEnemy(forceBomb: ForceBomb = .random) {
            let enemy: SKSpriteNode
            
            var enemyType = Int.random(in: 0...6)
            
            if forceBomb == .never {
                enemyType = PENGUIN_TYPE
            } else if forceBomb == .always {
                enemyType = BOMB_TYPE
            }
            
            if enemyType == BOMB_TYPE {
                enemy = SKSpriteNode()
                enemy.zPosition = 1
                enemy.name = "bombContainer"
                
                let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
                bombImage.name = "bomb"
                enemy.addChild(bombImage)
                
                if bombSoundEffect != nil {
                    bombSoundEffect?.stop()
                    bombSoundEffect = nil
                }
                
                if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: "caf") {
                    if let sound = try? AVAudioPlayer(contentsOf: path) {
                        bombSoundEffect = sound
                        sound.play()
                    }
                }
                
                if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                    emitter.position = CGPoint(x: 76, y: 64)
                    enemy.addChild(emitter)
                }
            } else if enemyType == BONUS_TYPE {
                enemy = SKSpriteNode(imageNamed: "sliceLife")
                run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
                enemy.name = "bonus"
            } else {
                enemy = SKSpriteNode(imageNamed: "penguin")
                run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
                enemy.name = "enemy"
            }
            
            let randomPosition = CGPoint(x: Int.random(in: MAX_LEFT_SCREEN...MAX_RIGHT_SCREEN), y: MAX_TOP_SCREEN)
            enemy.position = randomPosition
            
            let randomAngularVelocity = CGFloat.random(in: MIN_ANGULAR_VELOCITY...MAX_ANGULAR_VELOCITY)
            var randomXVelocity: Int
            
            if randomPosition.x < LEFT_EDGE_SCREEN {
                randomXVelocity = Int.random(in: MED_SPEED...MAX_SPEED)
            } else if randomPosition.x < MIDDLE_SCREEN {
                randomXVelocity = Int.random(in: MIN_SPEED...MED_SPEED)
            } else if randomPosition.x < RIGHT_EDGE_SCREEN {
                randomXVelocity = -Int.random(in: MIN_SPEED...MED_SPEED)
            } else {
                randomXVelocity = -Int.random(in: MAX_SPEED...TOP_SPEED)
            }
            
            let randomYVelocity = Int.random(in: MIN_Y_SPEED...MAX_Y_SPEDD)
            
            enemy.physicsBody = SKPhysicsBody(circleOfRadius: PHYSICS_BODY_RADIUS)
            
            if enemyType == BONUS_TYPE {
                randomXVelocity *= 2
            }
            
            enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * PHYSICS_SPEED_CONSTANT, dy: randomYVelocity * PHYSICS_SPEED_CONSTANT)
            enemy.physicsBody?.angularVelocity = randomAngularVelocity
            enemy.physicsBody?.collisionBitMask = 0
            
            addChild(enemy)
            activeEnemies.append(enemy)
        }
        ```

        ```swift
        override func update(_ currentTime: TimeInterval) {
            if activeEnemies.count > 0 {
                for (index, node) in activeEnemies.enumerated().reversed() {
                    if node.position.y < -140 {
                        node.removeAllActions()
                        
                        if node.name == "enemy" {
                            node.name = ""
                            subtractLife()
                            
                            node.removeFromParent()
                            activeEnemies.remove(at: index)
                        } else if node.name == "bombContainer" || node.name == "bonus" {
                            node.name = ""
                            node.removeFromParent()
                            activeEnemies.remove(at: index)
                        }
                    }
                }
            } else {
                if !nextSequenceQueued {
                    DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in
                        self?.tossEnemies()
                    }
                    
                    nextSequenceQueued = true
                }
            }
            
            var bombCount = 0
            
            for node in activeEnemies {
                if node.name == "bombContainer" {
                    bombCount += 1
                    break
                }
                
                if bombCount == 0 {
                    bombSoundEffect?.stop()
                    bombSoundEffect = nil
                }
            }
        }
        ```

    2. Add a “Game over” sprite node to the game scene when the player loses all their lives.

        ```swift
        func endGame(triggeredByBomb: Bool) {
            guard isGameEnded == false else { return }
            
            let gameOverLabel = SKLabelNode(fontNamed: "Helvetica Neue Bold")
            gameOverLabel.text = "Game Over"
            gameOverLabel.position = CGPoint(x: 512, y: 384)
            gameOverLabel.horizontalAlignmentMode = .center
            gameOverLabel.fontSize = 40
            gameOverLabel.zPosition = 3
            addChild(gameOverLabel)
            
            isGameEnded = true
            physicsWorld.speed = 0
            isUserInteractionEnabled = false
            
            bombSoundEffect?.stop()
            bombSoundEffect = nil
            
            if triggeredByBomb {
                livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
                livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
                livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
            }
        }
        ```