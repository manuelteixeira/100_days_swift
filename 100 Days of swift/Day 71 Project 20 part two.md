# Day 71 - Project 20, part two

- **Making things go bang: SKEmitterNode**

    There are three things we need to create: a **method to explode a single firework**, a **method to explode all the fireworks** (which will call the single firework explosion method), and **some code to detect and respond the device being shaken**.

    ```swift
    func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)
        }

        firework.removeFromParent()
    }
    ```

    It creates an explosion where the firework was, then removes the firework from the game scene.

    The **`explodeFireworks()`** will be triggered **when the user wants to set off their selected fireworks**, so it n**eeds to loop through the fireworks array** (backwards again!), **pick out any selected ones**, **then call `explode()` on it.**

    ```swift
    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

            if firework.name == "selected" {
                // destroy this firework!
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }
    ```

    There's one last thing to do before this game is complete, and that's to **detect the device being shaken**. This is easy enough to do because **iOS will automatically call a method called** **`motionBegan()`** on our **game when the device is shaken**. Well, it's a little more complicated than that – what actually happens is that **the method gets called in `GameViewController.swift`**, **which is the `UIViewController` that hosts our `SpriteKit` game scene.**

    **The default view controller doesn't know that it has a `SpriteKit` view, and certainly doesn't know what scene is showing**, so we need to do a little typecasting. Once we have a reference to our actual game scene, we can call **`explodeFireworks()`**.

    ```swift
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard let skView = view as? SKView else { return }
        guard let gameScene = skView.scene as? GameScene else { return }
        gameScene.explodeFireworks()
    }
    ```

- **Challenge**

    1. For an easy challenge try adding a score label that updates as the player’s score changes.

        ```swift
        scoreLabel = SKLabelNode()
        scoreLabel.position = CGPoint(x: 100, y: 16)
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        ```

    2. Make the game end after a certain number of launches. You will need to use the **`invalidate()`** method of **`Timer`** to stop it from repeating.

        ```swift
        @objc func launchFireworks() {
            guard numLaunches < maximumLaunches else {
                gameTimer?.invalidate()
                return
            }
        		//...
        		
        		numLaunches += 1
        }
        ```

    3. Use the **`waitForDuration`** and **`removeFromParent`** actions in a sequence to make sure explosion particle emitters are removed from the game scene when they are finished.

        ```swift
        func explode(firework: SKNode) {
            if let emitter = SKEmitterNode(fileNamed: "explode") {
                emitter.position = firework.position
                addChild(emitter)
                
                let waitAction = SKAction.wait(forDuration: 3)
                let removeAction = SKAction.removeFromParent()
                
                let sequence = SKAction.sequence([waitAction, removeAction])
                emitter.run(sequence)
            }
            
            firework.removeFromParent()
        }
        ```