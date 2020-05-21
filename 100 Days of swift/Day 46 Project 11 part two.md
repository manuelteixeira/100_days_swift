# Day 46 - Project 11, part two

- **Spining slots: SKAction**

    **We'll be filling the gaps with two types of target slots**: good ones (colored **green**) and bad ones (colored **red**). 

    As with bouncers, **we'll need to place a few of these**, which means **we need to make a method**. **This needs to load the slot base graphic**, **position** it **where we said**, **then add it to the scene**, like this:

    ```swift
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
        }

        slotBase.position = position
        addChild(slotBase)
    }
    ```

    Unlike **`makeBouncer(at:)`**, this method **has a second parameter** – whether the slot is good or not – and **that affects which image gets loaded**. But first, we need to call the new method, so add these lines just before the calls to **`makeBouncer(at:)` in `didMove(to:)`**:

    ```swift
    makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
    makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
    makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
    makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
    ```

    We can **make the slot colors look more obvious** by **adding a glow image behind them**:

    ```swift
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        }

        slotBase.position = position
        slotGlow.position = position

        addChild(slotBase)
        addChild(slotGlow)
    }
    ```

    **We could** even **make the slots spin slowly** by **using** a new class called **`SKAction`**. 

    - **Angles** are specified in **radians**, **not degrees**. This **is true in UIKit too**. **360 degrees is equal to the value of 2 x Pi** – that is, the mathematical value π. Therefore **π radians is equal to 180 degrees.**
    - Rather than have you try to memorize it, there is a built-in value of π called **`CGFloat.pi`**.
    - Yes **`CGFloat`** is yet another way of representing decimal numbers, just like **`Double`** and **`Float`**. Behind the scenes, **`CGFloat`** **can be either a `Double` or a `Float` depending on the device your code runs on.** Swift also has **`Double.pi`** and **`Float.pi`** for when you need it at different precisions.
    - **When you create an action it will execute once.** **If you want it to run forever, you create another action to wrap the first using the `repeatForever()` method**, then run that.

    Put this code just before the end of the **`makeSlot(at:)`** method:

    ```swift
    let spin = SKAction.rotate(byAngle: .pi, duration: 10)
    let spinForever = SKAction.repeatForever(spin)
    slotGlow.run(spinForever)
    ```

- **Collision detection: SKPhysicsContactDelegate**

    In this game, **we want the player to win or lose depending on how many green or red slots they hit**, so we need to make a few changes:

    1. **Add rectangle physics to our slots.**
    2. **Name the slots** so we know which is which, then **name the balls** too.
    3. **Make our scene the contact delegate of the physics world** – this means, "tell us when contact occurs between two bodies."
    4. **Create a method that handles contacts** and does something appropriate.

    The first step is easy enough: add these two lines just before you call **`addChild()`** for **`slotBase`**:

    ```swift
    slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
    slotBase.physicsBody?.isDynamic = false
    ```

    **Apple recommends assigning names to your nodes**, then checking the name to see what node it is. 

    **We need to have three names** in our code: **good slots**, **bad slots** and **balls**.

    ```swift
    if isGood {
        slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
        slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
        slotBase.name = "good"
    } else {
        slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
        slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
        slotBase.name = "bad"
    }
    ```

    ```swift
    ball.name = "ball"
    ```

    We **need to conform to the `SKPhysicsContactDelegate`** protocol **then assign the physics world's `contactDelegate` property to be our scene**. But by default, you still won't get notified when things collide.

    What we need to do is **change the `contactTestBitMask` property of our physics objects**, which **sets the contact notifications we want to receive**. 

    ```swift
    class GameScene: SKScene, SKPhysicsContactDelegate { ... }
    ```

    ```swift
    physicsWorld.contactDelegate = self
    ```

    **We're going to tell all the ball nodes to set their** **`contactTestBitMask`** property **to be equal to their** **`collisionBitMask`**.

    The **`collisionBitMask`** bitmask **means** "**which nodes should I bump into**?" **By default, it's set to everything**, which is why our ball are already hitting each other and the bouncers. 

    The **`contactTestBitMask`** bitmask **means** "**which collisions do you want to know about?**" and **by default it's set to nothing**. 

    So **by setting `contactTestBitMask` to the value of `collisionBitMask` we're saying, "tell me about every collision."**

    This isn't particularly efficient in complicated games, but it will make no difference at all in this current project.

    ```swift
    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
    ```

    **When contact between two physics bodies occurs**, **we don't know what order it will come in.** That is, **did the ball hit the slot**, **did the slot hit the ball**, **or did both happen**?

    The first one, **`collisionBetween()`** **will be called when a ball collides with something else.** 

    The second one, **`destroy()`** is **going to be called when we're finished with the ball and want to get rid of it.**

    ```swift
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
        } else if object.name == "bad" {
            destroy(ball: ball)
        }
    }

    func destroy(ball: SKNode) {
        ball.removeFromParent()
    }
    ```

    **We'll get told which two bodies collided**, and **the contact method needs to determine which one is the ball so that it can call `collisionBetween()`** **with the correct parameters**. 

    This is as **simple as checking the names of both properties** to see which is the ball, so here's the new method to do contact checking:

    ```swift
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.node?.name == "ball" {
            collisionBetween(ball: contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node?.name == "ball" {
            collisionBetween(ball: contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
    ```

    You may have noticed that **we don't have a special case in there for when both bodies are balls** – i.e., if one ball collides with another. This is because our **`collisionBetween()`** method **will ignore that particular case**, because **it triggers code only if the other node is named "good" or "bad".**

    “did the ball hit the slot, did the slot hit the ball, or did both happen?” **That last case won’t happen all the time, but it will happen sometimes, and it’s important to take it into account.**

    If SpriteKit reports a collision twice – i.e. “ball hit slot and slot hit ball” – then we have a problem. 

    The first time that code runs, **we force unwrap both nodes and remove the ball** – so far so good. 

    The second time that code runs (for the other half of the same collision), **our problem strikes: we try to force unwrap something we already removed, and our game will crash.**

    To solve this, we’re going to rewrite the **`didBegin()`** method.

    We’ll use **`guard`** **to ensure both `bodyA` and `bodyB` have nodes attached.** If either of them don’t then this is a ghost collision and we can bail out immediately.

    ```swift
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    ```

- **Scores on the board: SKLabelNode**

    To make a score show on the screen we need to do two things: **create a score integer that tracks the value itself**, then **create a new node type, `SKLabelNode`, that displays the value to players.**

    ```swift
    var scoreLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    ```

    We're going to use the Chalkduster font, then align the label to the right and position it on the top-right edge of the scene. Put this code into your **`didMove(to:)`** method

    ```swift
    scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
    scoreLabel.text = "Score: 0"
    scoreLabel.horizontalAlignmentMode = .right
    scoreLabel.position = CGPoint(x: 980, y: 700)
    addChild(scoreLabel)
    ```

    ```swift
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    ```

    We're going to let you **place obstacles between the top of the scene and the slots at the bottom**, so that players have to position their balls exactly correctly to bounce off things in the right ways.

    ```swift
    var editLabel: SKLabelNode!

    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    ```

    ```swift
    editLabel = SKLabelNode(fontNamed: "Chalkduster")
    editLabel.text = "Edit"
    editLabel.position = CGPoint(x: 80, y: 700)
    addChild(editLabel)
    ```

    But what is new is **detecting whether the user tapped the edit/done button or is trying to create a ball**. To make this work, **we're going to ask SpriteKit to give us a list of all the nodes at the point that was tapped**, and **check whether it contains our edit label**. If it does, we'll flip the value of our editingMode boolean; if it doesn't, we want to execute the previous ball-creation code.

    ```swift
    let location = touch.location(in: self)

    let objects = nodes(at: location)

    if objects.contains(editLabel) {
        editingMode.toggle()
    } else {
        let ball = SKSpriteNode(imageNamed: "ballRed")
        // rest of ball code
    }
    ```

    ```swift
    if objects.contains(editLabel) {
        editingMode.toggle()
    } else {
        if editingMode {
            // create a box
        } else {
            // create a ball
        }
    }
    ```

    First, we're going to **use a new property on nodes called `zRotation`**. **When creating the background image, we gave it a Z position, which adjusts its depth on the screen**, front to back. 

    If you imagine sticking a skewer through the Z position – i.e., going directly into your screen – and through a node, then you can imagine Z rotation: **it rotates a node on the screen as if it had been skewered straight through the screen.**

    To **create randomness we’re going to be using both `Int.random(in:)` for integer values and `CGFloat.random(in:)` for CGFloat values.**

    ```swift
    let size = CGSize(width: Int.random(in: 16...128), height: 16)
    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
    box.zRotation = CGFloat.random(in: 0...3)
    box.position = location

    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
    box.physicsBody?.isDynamic = false

    addChild(box)
    ```

    So, we **create a size with a height of 16 and a width between 16 and 128, then create an SKSpriteNode with the random size** we made **along with a random color**, then **give the new box a random rotation and place it at the location that was tapped on the screen**. For a **physics body, it's just a rectangle, but we need to make it non-dynamic so the boxes don't move when hit.**