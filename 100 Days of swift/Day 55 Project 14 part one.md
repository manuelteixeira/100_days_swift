# Day 55 - Project 14, part one

- **Getting up and running: SKCropNode**

    Add these two properties to your **`GameScene`** class:

    ```swift
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    ```

    Now modify your **`didMove(to:)`** method so it reads this:

    ```swift
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
    }
    ```

    We want each hole to do as much work itself as possible, so rather than clutter our game scene with code we're going to create a subclass of **`SKNode`** that will encapsulate all hole related functionality.

    You've already met **`SKSpriteNode`**, **`SKLabelNode`** and **`SKEmitterNode`**, and they all come from **`SKNode`**. This base class doesn't draw images like sprites or hold text like labels; **it just sits in our scene at a position, holding other nodes as children.**

    ```swift
    func configure(at position: CGPoint) {
        self.position = position

        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
    }
    ```

    **If you don't create any custom initializers** (and don't have any non-optional properties) **Swift will just use the parent class's `init()` methods**.

    **We want to create four rows of slots**, with **five slots in the top row**, **then four in the second**, **then five**, **then four**. 

    This creates quite a pleasing shape, but as we're creating lots of slots we're going to need three things:

    1. An array in which we can store all our slots for referencing later.
    2. A **`createSlot(at:)`** method that handles slot creation.
    3. Four loops, one for each row.

    ```swift
    var slots = [WhackSlot]()
    ```

    We need to **create a method that accepts a position**, **then creates a `WhackSlot` object, calls its `configure(at:)` method, then adds the slot both to the scene and to our array**:

    ```swift
    func createSlot(at position: CGPoint) {
        let slot = WhackSlot()
        slot.configure(at: position)
        addChild(slot)
        slots.append(slot)
    }
    ```

    The only moderately hard part of this task is the four loops that call **`createSlot(at:)`** because you need to figure out what positions to use for the slots. Put this just before the end of **`didMove(to:)`**

    ```swift
    for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
    for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
    for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
    for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
    ```

    **`SKCropNode`** This is a **special kind of `SKNode` subclass that uses an image as a cropping mask: anything in the colored part will be visible**, **anything in the transparent part will be invisible**.

    In WhackSlot.swift, add a property to your class in which we'll store the penguin picture node:

    ```swift
    var charNode: SKSpriteNode!
    ```

    Now add this just before the end of the **`configure(at:)`** method:

    ```swift
    let cropNode = SKCropNode()
    cropNode.position = CGPoint(x: 0, y: 15)
    cropNode.zPosition = 1
    cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")

    charNode = SKSpriteNode(imageNamed: "penguinGood")
    charNode.position = CGPoint(x: 0, y: -90)
    charNode.name = "character"
    cropNode.addChild(charNode)

    addChild(cropNode)
    ```

    First, **we create a new `SKCropNode` and position it slightly higher than the slot itself**. The number 15 isn't random – it's the exact number of points required to make the crop node line up perfectly with the hole graphics. We **also give the crop node a zPosition value of 1**, **putting it to the front of other nodes**, which stops it from appearing behind the hole.

    We then create the character node, giving it the "good penguin" graphic, which is a blue color – the bad penguins are red, presumably because they are bubbling over with hellfire or something. 

    This **is placed at -90**, which **is way below the hole as if the penguin were properly hiding**.

    I hope you noticed the important thing, which is that **the character node is added to the crop node, and the crop node was added to the slot. This is because the crop node only crops nodes that are inside it, so we need to have a clear hierarchy:** the slot has the hole and crop node as children, and the crop node has the character node as a child.

    Remember, with **crop nodes everything with a color is visible, and everything transparent is invisible, so the whackMask.png will show all parts of the character that are above the hole.**

- **Penguin, show thyself: SKAction moveBy(x:y:duration:)**

    Put these two properties at the top of your **`WhackSlot`** class:

    ```swift
    var isVisible = false
    var isHit = false
    ```

    Showing a penguin for the player to tap on will be handled by a new method called **`show()`**. This will **make the character slide upwards so it becomes visible, then set `isVisible` to be true and `isHit` to be false**. 

    The **movement is going to be created by a new `SKAction`**, called **`moveBy(x:y:duration:)`**.

    **This method will also decide whether the penguin is good or bad** – i.e., whether the player should hit it or not. This will be done using Swift’s Int.random() method: one-third of the time the penguin will be good; the rest of the time it will be bad.

    **To make it clear to the player which is which, we have two different pictures: penguinGood and penguinEvil**. We can **change the image inside our penguin sprite by changing its texture property**. **This takes a new class called** **`SKTexture`**, which is to **`SKSpriteNode`** sort of what **`UIImage`** is to **`UIImageView`** – **it holds image data, but isn't responsible for showing it.**

    **Changing the character node's texture like this is helpful because it means we don't need to keep adding and removing nodes**. Instead, we can just change the texture to match what kind of penguin this is, then change the node name to match so we can do tap detection later on.

    ```swift
    func show(hideTime: Double) {
        if isVisible { return }

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

    		DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
    		    self?.hide()
    		}
    }
    ```

    The **`show()`** method **is going to be triggered by the view controller on a recurring basis, managed by a property we're going to create called `popupTime`**. This will start at 0.85 (create a new enemy a bit faster than once a second), but **every time we create an enemy we'll also decrease `popupTime` so that the game gets harder over time.**

    ```swift
    var popupTime = 0.85
    ```

    To jump start the process, **we need to call `createEnemy()` once when the game starts, then have `createEnemy()` call itself thereafter**. 

    So, in **`didMove(to:)`** we're going to call the **`createEnemy()`** method after a delay. This requires some new **Grand Central Dispatch (GCD)** code: **`asyncAfter()`** is **used to schedule a closure to execute after the time has been reached.**

    ```swift
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
        self?.createEnemy()
    }
    ```

    The deadline parameter to **`asyncAfter()`** means “**1 second after now,**” giving us the 1-second delay.

    Now, onto the **`createEnemy()`** method. This will do several things:

    - **Decrease** **`popupTime`** **each time it's called**. I'm going to multiply it by 0.991 rather than subtracting a fixed amount, otherwise the game gets far too fast.
    - **Shuffle the list of available slots** using the **`shuffle()`** method we've used previously.
    - **Make the first slot show itself**, passing in the current value of **`popupTime`** for the method to use later.
    - **Generate four random numbers to see if more slots should be shown**. Potentially up to five slots could be shown at once.
    - **Call itself again after a random delay**. The delay will be between **`popupTime`** halved and **`popupTime`** doubled. For example, if **`popupTime`** was 2, the random number would be between 1 and 4.

    ```swift
    func createEnemy() {
        popupTime *= 0.991

        slots.shuffle()
        slots[0].show(hideTime: popupTime)

        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)  }

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    ```

    Before we're done, we need to upgrade the **`WhackSlot`** class to include a **`hide()`** method. We're already passing a **`hideTime`** parameter to the **`show()`** method, and **we're going to use that so the slots hide themselves after they have been visible for a time.**

    ```swift
    func hide() {
        if !isVisible { return }

        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        isVisible = false
    }
    ```