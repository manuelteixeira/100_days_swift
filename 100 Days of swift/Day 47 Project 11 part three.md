# Day 47 - Project 11, part three

- **Special effects: SKEmitterNode**

    **SpriteKit has a built-in particle editor** to help you create effects like fire, snow, rain and smoke almost entirely through a graphical editor. 

    ```swift
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }

        ball.removeFromParent()
    }
    ```

    The **`SKEmitterNode`** class is new and powerful: it's **designed to create high-performance particle effects in SpriteKit games,** and **all you need to do is provide it with the filename of the particles you designed and it will do the rest**. 

    Once we have an **`SKEmitterNode`** object to work with, **we position it where the `ball` was then use `addChild()` to add it to the scene.**

    The particle editor is split in two: the center area shows how the current particle effect looks, and the right pane shows one of three inspectors. Of those three inspectors, only the third is useful because that's where you'll see all the options you can use to change the way your particles look.

    Confused by all the options? Here's what they do:

    - **Particle Texture**: **what image to use for your particles.**
    - **Particles Birthrate**: **how fast to create new particles**.
    - **Particles Maximum**: the **maximum number of particles this emitter should create before finishing**.
    - **Lifetime Start**: the **basic value for how many seconds each particle should live for.**
    - **Lifetime Range**: **how much, plus or minus, to vary lifetime.**
    - **Position Range X/Y**: **how much to vary the creation position of particles from the emitter node's position.**
    - **Angle Start**: **which angle you want to fire particles**, **in** **degrees**, where 0 is to the right and 90 is straight up.
    - **Angle Range**: **how many degrees to randomly vary particle angle**.
    - **Speed Start**: **how fast each particle should move in its direction.**
    - **Speed Range**: **how much to randomly vary particle speed.**
    - **Acceleration X/Y**: **how much to affect particle speed over time.** This can be used to simulate gravity or wind.
    - **Alpha Start**: **how transparent particles are when created**.
    - **Alpha Range**: **how much to randomly vary particle transparency.**
    - **Alpha Speed**: **how much to change particle transparency over time.** A negative value means "fade out."
    - **Scale Start / Range / Speed**: **how big particles should be when created, how much to vary it, and how much it should change over time.** A negative value means "shrink slowly."
    - **Rotation Start / Range / Speed**: **what Z rotation particles should have, how much to vary it, and how much they should spin over time.**
    - **Color Blend Factor / Range / Speed**: **how much to color each particle, how much to vary it, and how much it should change over time.**
- **Challenges**
    1. The pictures we’re using in have other ball pictures rather than just “ballRed”. Try writing code to use a random ball color each time they tap the screen.

        ```swift
        func generateRandomBallName() -> String {
            let colors = ["Green", "Blue", "Cyan", "Grey", "Purple", "Red", "Yellow"]
            
            let colorName = colors[Int.random(in: 0..<colors.count)]
            let randomBallName = "ball\(colorName)"
            
            return randomBallName
        }
        ```

    2. Right now, users can tap anywhere to have a ball created there, which makes the game too easy. Try to force the Y value of new balls so they are near the top of the screen.

        ```swift
        let ballLocation = CGPoint(x: location.x, y: 768)
        ball.position = ballLocation
        ...
        ```

    3. Give players a limit of five balls, then remove obstacle boxes when they are hit. Can they clear all the pins with just five balls? You could make it so that landing on a green slot gets them an extra ball.

        ```swift
        var ballsAvailableLabel: SKLabelNode!
        var ballsAvailable = 5 {
            didSet {
                ballsAvailableLabel.text = "Balls available: \(ballsAvailable)"
            }
        }
        ```

        ```swift
        ballsAvailableLabel = SKLabelNode(fontNamed: "ChalkDuster")
        ballsAvailableLabel.text = "Balls available: 5"
        ballsAvailableLabel.position = CGPoint(x: 300, y: 700)
        addChild(ballsAvailableLabel)
        ```

        ```swift
        else if ballsAvailable > 0 {
            let ballName = generateRandomBallName()
            let ball = SKSpriteNode(imageNamed: ballName)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
            ball.physicsBody?.restitution = 0.4
            ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
            let ballLocation = CGPoint(x: location.x, y: 768)
            ball.position = ballLocation
            ball.name = "ball"
            addChild(ball)
            ballsAvailable -= 1
        }
        ```

        ```swift
        box.name = "box"
        ```

        ```swift
        func collision(between ball: SKNode, object: SKNode) {
            if object.name == "good" {
                destroy(ball: ball)
                score += 1
                ballsAvailable += 1
            } else if object.name == "bad" {
                destroy(ball: ball)
                score -= 1
            } else if object.name == "box" {
                object.removeFromParent()
            }
        }
        ```