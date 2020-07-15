# Day 87 - Project 26, part three

- Challenge
    1. Rewrite the **`loadLevel()`** method so that it's made up of multiple smaller methods. This will make your code easier to read and easier to maintain, or at least it should do if you do a good job!

        ```swift
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
        ```

        ```swift
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
            case " ":
                return
            default:
                fatalError("Unknown level letter: \(letter)")
            }
        }
        ```

    2. When the player finally makes it to the finish marker, nothing happens. What should happen? Well, that's down to *you* now. You could easily design several new levels and have them progress through.

        ```swift
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
            }
        }
        ```

    3. Add a new block type, such as a teleport that moves the player from one teleport point to the other. Add a new letter type in **`loadLevel()`**, add another collision type to our enum, then see what you can do.

        ```swift
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
        ```

        ```swift
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
        ```