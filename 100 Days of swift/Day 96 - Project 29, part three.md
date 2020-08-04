# Day 96 - Project 29, part three

- Challenge

    1. Add code and UI to track the player scores across levels, then make the game end after one player has won three times.

        ```swift
        @IBOutlet weak var player1ScoreLabel: UILabel!
        @IBOutlet weak var player2ScoreLabel: UILabel!
        ```

        ```swift
        func destroy(player: SKSpriteNode) {
            if let explosion = SKEffectNode(fileNamed: "hitPlayer") {
                explosion.position = player.position
                addChild(explosion)
            }
            
            player.removeFromParent()
            banana.removeFromParent()
            
            if player1Score == maxPlayersScore || player2Score == maxPlayersScore {
                player1.removeFromParent()
                player2.removeFromParent()
                banana.removeFromParent()
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                let newGame = GameScene(size: self.size)
                newGame.viewController = self.viewController
                self.viewController?.currentGame = newGame
                
                newGame.player1Score = self.player1Score
                newGame.player2Score = self.player2Score
                self.viewController?.player2ScoreLabel.text = "Score: \(self.player2Score)"
                self.viewController?.player1ScoreLabel.text = "Score: \(self.player1Score)"

                self.changePlayer()
                newGame.currentPlayer = self.currentPlayer
                
                let transition = SKTransition.doorway(withDuration: 1.5)
                self.view?.presentScene(newGame, transition: transition)
            }
        }
        ```

        ```swift
        if firstNode.name == "banana" && secondNode.name == "player1" {
            player2Score += 1
            destroy(player: player1)
            viewController?.player2ScoreLabel.text = "Score: \(player2Score)"
        }

        if firstNode.name == "banana" && secondNode.name == "player2" {
            player1Score += 1
            destroy(player: player2)
            viewController?.player1ScoreLabel.text = "Score: \(player1Score)"
        }
        ```

    2. Add Auto Layout rules for the UI components in our storyboard, allowing them to remain positioned neatly regardless of which iPad size is used.

        ```swift
        // See code
        ```

    3. Use the physics world’s gravity to add random wind to each level, making sure to add a label telling players the direction and strength.

        ```swift
        func updateWindLabel(_ currentGame: GameScene) {
            if currentGame.wind > 0 {
                windDirectionLabel.text = "Wind direction >>>>>"
            } else if currentGame.wind < 0 {
                windDirectionLabel.text = "<<<<< Wind direction"
            } else {
                windDirectionLabel.text = "No wind"
            }
        }
        ```

        ```swift
        func generateRandomWind() -> CGVector {
            wind = CGFloat.random(in: -20...20)

            return CGVector(dx: wind, dy: 0)
        }
        ```

        ```swift
        override func didMove(to view: SKView) {
            backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
            createBuildings()
            createPlayers()
            
            physicsWorld.contactDelegate = self
            physicsWorld.gravity = generateRandomWind()
            
            viewController?.player2ScoreLabel.text = "Score: \(player2Score)"
            viewController?.player1ScoreLabel.text = "Score: \(player1Score)"
        }
        ```