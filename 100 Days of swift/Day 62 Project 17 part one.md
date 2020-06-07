# Day 62 - Project 17, part one

- **Space: the final frontier**

    To begin with we're going to place a handful of things that are required to make our game work: a star field (not a static background picture this time), the player image, plus a score label. **Those three things will use an `SKEmitterNode`, an `SKSpriteNode` and an `SKLabelNode` respectively, so let's declare them as properties now:**

    ```swift
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!

    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    ```

    In order to get those properties set up with meaningful values, we're going to put a lot of code into **`didMove(to:)`** so that everything is created and positioned up front.

    First, the **star field particle emitter is positioned at X:1024 Y:384**, which is the **right edge of the screen and half way up**. If you created particles like this normally it would look strange, because most of the screen wouldn't start with particles and they would just stream in from the right. But **by using the `advanceSimulationTime()`** method of the emitter **we’re going to ask `SpriteKit` to simulate 10 seconds passing in the emitter**, thus **updating all the particles as if they were created 10 seconds ago**. **This will have the effect of filling our screen with star particles.**

    Second, **because the spaceship is an irregular shape and the objects in space are also irregula**r, **we're going to use per-pixel collision detection**. This means **collisions happen not based on rectangles and circles but based on actual pixels from one object touching actual pixels in another.**

    **You should still only use it when it's needed. If something can be created as a rectangle or a circle you should do so because it's much faster**.

    Third, we're going to **set the contact test bit mask for our player to be 1.** **This will match the category bit mask we will set for space debris later on, and it means that we'll be notified when the player collides with debris.**

    Fourth, **I'm going to set the gravity of our physics world to be empty, because this is space and there isn't any gravity**. 

    ```swift
    override func didMove(to view: SKView) {
        backgroundColor = .black

        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
    }
    ```

- **Bring on the enemies: linearDamping, angularDamping**

    To add enemies and time to the game, we need to declare three new properties:

    ```swift
    let possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    var gameTimer: Timer?
    ```

    The **`possibleEnemies`** array **contains the names of the three images that can be used as space debris in the game**: a ball, a hammer and a TV. The **`isGameOver`** is a **simple boolean that will be set to true when we should stop increasing the player's score.**

    The third property is a new type, called **`Timer`**. This is r**esponsible for running code after a period of time has passed, either once or repeatedly.**

    When you create an Timer you specify five parameters: h**ow many seconds you want the delay to be, what object should be told when the timer fires, what method should be called on that object when the timer fires, any context you want to provide, and whether the time should repeat.**

    We need to create a new enemy on a regular basis, so the first thing to do is create a scheduled timer. I'm going to **give it a timer interval of 0.35 seconds, so it will create about three enemies a second**. Put this code into **`didMove(to:)`**:

    ```swift
    gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    ```

    **Tip**: The scheduledTimer() timer not only creates a timer, but also starts it immediately.

    Creating an enemy needs to use techniques that you've mostly seen already: it will **shuffle the possibleEnemies array, create a sprite node using the first item in that array, position it off the right edge and with a random vertical position, then add it to the scene.**

    But we're also going to **set to 0 its `linearDamping` and `angularDamping` properties**, which **means its movement and rotation will never slow down over time**. Perfect for a frictionless space environment!

    ```swift
    @objc func createEnemy() {
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
    }
    ```

    Now that lots of debris will appear, **we need to make sure we remove their nodes once they are invisible**. In this game, that means removing nodes from the scene once they are effectively useless because they have passed the player. This will be done using a check in the **`update()`** method: **if any node is beyond X position -300, we'll consider it dead.**

    The **`update()`** method is also a good place to make our score increment all the time. All **we need to do is check whether `isGameOver` is still false, and add one to the score if so. Here's the code for the `update()`** method:

    ```swift
    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }

        if !isGameOver {
            score += 1
        }
    }
    ```

- **Making contact: didBegin()**

    **Handling player movement** is as simple as **implementing** the **`touchesMoved()`** method. We will, like always, **need to use the `location(in:)` method to figure out where on the screen the user touched.** But this time we're going to **clamp the player's Y position**, which in plain English **means that we're going to stop them going above or below a certain point**, keeping them firmly in the game area.

    I'll be clamping the player's position so they can't overlap the score label, and I'll apply the same restriction on top so that the player has a symmetrical channel to fly through. This is a cinch to do, so here's the **`touchesMoved()`** method:

    ```swift
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        player.position = location
    }
    ```

    Our last task is to end the game when the player hits any piece of space debris. This is all code you know already: **we're going to create a particle emitter, position it where the player is (or was!), and add the explosion to the scene while removing the player**. **In this game we're also going to set isGameOver to be true so that the update() method stops adding to their score**. Here's all the code:

    ```swift
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)

        player.removeFromParent()

        isGameOver = true
    }
    ```