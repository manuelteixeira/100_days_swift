# Day 56 - Project 14, part two

- **Whack to win: SKAction sequences**

    We're going to add a **`hit()`** method to the **`WhackSlot`** class that will handle hiding the penguin. **This needs to wait for a moment** (so the player still sees what they tapped), **move the penguin back down again**, then **set the penguin to be invisible again**.

    We're going to use an **`SKAction`** for each of those three things, which means you need to learn some new uses of the class:

    - **`SKAction.wait(forDuration:)`** creates an action that waits for a period of time, measured in seconds.
    - **`SKAction.run(block:)`** will run any code we want, provided as a closure. "Block" is Objective-C's name for a Swift closure.
    - **`SKAction.sequence()`** takes an array of actions, and executes them in order. Each action won't start executing until the previous one finished.

    We need to use **`SKAction.run(block:)`** in order to **set the penguin's isVisible property to be false rather than doing it directly, because we want it to fit into the sequence**. Using this technique, **it will only be changed when that part of the sequence is reached.**

    ```swift
    func hit() {
        isHit = true

        let delay = SKAction.wait(forDuration: 0.25)
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    ```

    With that new method in place, we can call it from the **`touchesBegan()`** method in GameScene.swift. **This method needs to figure out what was tapped using the nodes(at:).** Find any touch, find out where it was tapped, then get a node array of all nodes at that point in the scene.

    ```swift
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

    		for node in tappedNodes {
    		    guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
    		    if !whackSlot.isVisible { continue }
    		    if whackSlot.isHit { continue }
    		    whackSlot.hit()
    		
    		    if node.name == "charFriend" {
    		        // they shouldn't have whacked this penguin
    		        score -= 5
    		
    		        run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
    		    } else if node.name == "charEnemy" {
    		        // they should have whacked this one
    		        whackSlot.charNode.xScale = 0.85
    		        whackSlot.charNode.yScale = 0.85
    		        score += 1
    		
    		        run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
    		    }
    		}
    }
    ```

    You're also going to meet a new piece of code: SKAction's **`playSoundFileNamed()`** method, which **plays a sound and optionally waits for the sound to finish playing before continuing** – useful if you're using an action sequence.

    To fix this final problem and bring the project to a close, we're going to limit the game to **creating just 30 rounds of enemies**. Each round is one call to **`createEnemy()`**, which means it might create up to five enemies at a time.

    ```swift
    var numRounds = 0
    ```

    Every time **`createEnemy()`** is called, we're going to add 1 to the **`numRounds`** property. **When it is greater than or equal to 30, we're going to end the game: hide all the slots, show a "Game over" sprite, then exit the method. Put this code just before the `popupTime`** assignment in **`createEnemy()`:**

    ```swift
    numRounds += 1

    if numRounds >= 30 {
        for slot in slots {
            slot.hide()
        }

        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.position = CGPoint(x: 512, y: 384)
        gameOver.zPosition = 1
        addChild(gameOver)

        return
    }
    ```

- **Challenge**
    1. Record your own voice saying "Game over!" and have it play when the game ends.

        ```swift
        run(SKAction.playSoundFileNamed("gameover.m4a", waitForCompletion: false))
        ```

    2. When showing “Game Over” add an **`SKLabelNode`** showing their final score.

        ```swift
        let finalScore = SKLabelNode()
        finalScore.text = "Your final score is \(score)"
        finalScore.fontSize = 48
        finalScore.position = CGPoint(x: 512, y: 284)
        addChild(finalScore)
        ```

    3. Use **`SKEmitterNode`** to create a smoke-like effect when penguins are hit, and a separate mud-like effect when they go into or come out of a hole.

        ```swift
        func hit() {
            isHit = true
            
            let delay = SKAction.wait(forDuration: 0.25)
            let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
            let notVisible = SKAction.run { [weak self] in
                self?.isVisible = false
            }
            
            if let smokeEffect = SKEmitterNode(fileNamed: "smoke.sks") {
                smokeEffect.position = charNode.position
                addChild(smokeEffect)
            }
            
            let sequence = SKAction.sequence([delay, hide, notVisible])
            charNode.run(sequence)
        }
        ```

        ```swift
        func show(hideTime: Double) {
            if isVisible { return }
            
            charNode.xScale = 1
            charNode.yScale = 1
            
            charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
            isVisible = true
            isHit = false
            
            if Int.random(in: 0...2) == 0 {
                charNode.texture = SKTexture(imageNamed: "penguinGood")
                charNode.name = "charFriend"
            } else {
                charNode.texture = SKTexture(imageNamed: "penguinEvil")
                charNode.name = "charEnemy"
            }
            
            if let spark = SKEmitterNode(fileNamed: "spark.sks") {
                spark.position = CGPoint(x: 0, y: 15)
                addChild(spark)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
                self?.hide()
            }
        }
        ```