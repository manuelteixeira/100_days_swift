# Day 63 - Project 17, part two

- **Challenge**
    1. Stop the player from cheating by lifting their finger and tapping elsewhere – try implementing **`touchesEnded()`** to make it work.

        ```swift
        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
            return
        }
        ```

    2. Make the timer start at one second, but then after 20 enemies have been made subtract 0.1 seconds from it so it’s triggered every 0.9 seconds. After making 20 more, subtract another 0.1, and so on. Note: you should call **`invalidate()`** on **`gameTimer`** before giving it a new value, otherwise you end up with multiple timers.

        ```swift
        @objc func createEnemy() {
            if (enemyCount == enemyMaxCount) {
                timerTriggerSeconds -= 0.1
                enemyCount = 0
                gamerTimer?.invalidate()
                gamerTimer = Timer.scheduledTimer(timeInterval: timerTriggerSeconds, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
            }
            
            guard let enemy = possibleEnemies.randomElement() else { return }
            
            let sprite = SKSpriteNode(imageNamed: enemy)
            sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
            addChild(sprite)
            
            sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
            sprite.physicsBody?.categoryBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.linearDamping = 0
            sprite.physicsBody?.angularDamping = 0
            
            enemyCount += 1
        }
        ```

    3. Stop creating space debris after the player has died.

        ```swift
        func didBegin(_ contact: SKPhysicsContact) {
            let explosion = SKEmitterNode(fileNamed: "explosion")!
            explosion.position = player.position
            addChild(explosion)
            
            player.removeFromParent()
            isGameOver = true
            
            for node in children {
                if node.name == "enemy" {
                    node.removeFromParent()
                }
            }
            
            gamerTimer?.invalidate()
        }
        ```