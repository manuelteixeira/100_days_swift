# Day 70 - Project 20, part one

- **Ready... aim.. fire: Timer and follow()**

    To get the game up and running quickly, we're going to work on the three methods required to launch some fireworks: **`didMove(to:)`** **will create a timer that launches fireworks every six seconds**, **`createFirework()`** **will create precisely one firework at a specific position** and **`launchFireworks()`** **will call `createFirework()` to create firework spreads.**

    First, the easy stuff: we need to add some properties to our class:

    - The **`gameTimer`** property will be a **`Timer`**. We'll **use this to call the `launchFireworks()` method every six seconds.**
    - The **`fireworks`** property will be an array of **`SKNode`** objects. **Fireworks will be a container node with other nodes inside them**. This avoids accidental taps triggered by tapping on the fuse of a firework.
    - The **`leftEdge`**, **`bottomEdge`**, and **`rightEdge`** properties are **used to define where we launch fireworks from**. Each of them will be just off screen to one side.
    - The **`score`** property will **track the player's score.**

    ```swift
    var scoreLabel: SKLabelNode!

    var gameTimer: Timer?
    var fireworks = [SKNode]()

    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    ```

    ```swift
    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFireworks), userInfo: nil, repeats: true)
    }
    ```

    First, let's take a look at the **`createFirework()`** method. **This needs to accept three parameters: the X movement speed of the firework, plus X and Y positions for creation**. Inside the method there's a lot going on. It needs to:

    1. Create an **`SKNode`** that will **act as the firework container, and place it at the position that was specified.**
    2. **Create a rocket sprite node**, **give it the name** "firework" so we know that it's the important thing, **adjust** its **`colorBlendFactor`** property **so that we can color it**, then **add it to the container node.**
    3. **Give the firework sprite node one of three random color**s: cyan, green or red. 
    4. **Create** a **`UIBezierPath`** that **will represent the movement of the firework.**
    5. **Tell the container node to follow that path**, turning itself as needed.
    6. **Create particles behind the rocket to make it look like the fireworks are lit.**
    7. **Add the firework to our `fireworks` array and also to the scene.**

    ```swift
    func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        // 1
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)

        // 2
        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.colorBlendFactor = 1
        firework.name = "firework"
        node.addChild(firework)

        // 3
        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan

        case 1:
            firework.color = .green

        case 2:
            firework.color = .red

        default:
            break
        }

        // 4
        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))

        // 5
        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)

        // 6
        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }

        // 7
        fireworks.append(node)
        addChild(node)
    }
    ```

    **The coloring process is done using two new properties**: **`color`** and **`colorBlendFactor`**. These two show off a simple but useful feature of SpriteKit, which is its ability to recolor your sprites dynamically with absolutely no performance cost. So, our rocket image is actually white, but by giving it .red with colorBlendFactor set to 1 (use the new color exclusively) it will appear red.

    Step five is done using a new **`SKAction`** you haven't seen before: **`follow()`**. **This takes a `CGPath` as its first parameter** (we'll pull this from the **`UIBezierPath`**) **and makes the node move along that path**. It doesn't have to be a straight line like we're using, any bezier path is fine.

    The **`follow()`** method **takes three** other **parameters**, all of which are useful. The **first decides whether the path coordinates are absolute or are relative to the node's current position**. If you specify **`asOffset`** as **`true`**, it **means any coordinates in your path are adjusted to take into account the node's position.**

    The third parameter **`orientToPath`** makes a complicated task into an easy one. **When it's set to** **`true`**, **the node will automatically rotate itself as it moves on the path so that it's always facing down the path**. 

    Now comes the **`launchFireworks()`** method, which will launch fireworks five at a time in four different shapes. As a result this method is quite long because it needs to call **`createFirework()`** 20 times, but really it's not difficult at all.

    ```swift
    @objc func launchFireworks() {
        let movementAmount: CGFloat = 1800

        switch Int.random(in: 0...3) {
        case 0:
            // fire five, straight up
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)

        case 1:
            // fire five, in a fan
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: -100, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 100, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 200, x: 512 + 200, y: bottomEdge)

        case 2:
            // fire five, from the left to the right
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 400)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 300)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 200)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge + 100)
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)

        case 3:
            // fire five, from the right to the left
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 400)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 300)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)

        default:
            break
        }
    }
    ```

- **Swipe to select**

    So, the challenge **will be to select and detonate fireworks based on their color**, and as you'll see shortly we're going to heavily bias scores so that players receive many more points for larger groups.

    What we're going to code now is the touch handling method, **`checkTouches()`**. We're going to call this from **`touchesBegan()`** and **`touchesMoved()`** so that users can either tap to select fireworks or just swipe across the screen.

    The method needs to **start by figuring out where in the scene the player touches**, **and what nodes are at that point**. It will t**hen loop through all nodes under the point to find any with the name "firework"**. **When it finds one, it will set its name to be "selected" rather than "firework" and change its `colorBlendFactor` value to 0**. **That will disable the color blending** entirely, **making the firework white**.

    **When we ask for all the nodes under the users finger we’ll get back an array of** **`SKNode`**, and that’s not good enough – **we can’t set the color blend factor of an `SKNode`**, because it might not have a texture. Instead, **what we want to do is go over only the sprite nodes in the returned array** – **we want to run the body of our loop only for sprite nodes, not for the other items.**

    This is where **`for case let`** comes in: it lets us attempts some work (typecasting to **`SKSpriteNode`** in this case), and r**un the loop body only for items that were successfully typecast.**

    ```swift
    func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }
            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }
    ```

    I **missed out the logic to handle ensuring that players select only one color at a time**. **The above code will let them select all the fireworks, regardless of color**.

    Remember, **this inner loop needs to ensure that the player can select only one firework color at a time**. So if they select red then another red, both are selected. But if they then select a green, we need to deselect the first two because they are red.

    So, the loop will go through every firework in our **`fireworks`** array, then find the firework image inside it. Remember, that array holds the container node, and each container node holds the firework image and its spark emitter. **If the firework was selected and is a different color to the firework that was just tapped, then we'll put its name back to `"firework"` and put its `colorBlendFactor` back to `1` so it resumes its old color.**

    ```swift
    for parent in fireworks {
        guard let firework = parent.children.first as? SKSpriteNode else { continue }

        if firework.name == "selected" && firework.color != node.color {
            firework.name = "firework"
            firework.colorBlendFactor = 1
        }
    }
    ```

    ```swift
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        checkTouches(touches)
    }
    ```

    There's one more thing we need to code before moving on, and that's some additions to the **`update()`** method. This is because **we need to handle the fireworks that the player doesn't destroy, and our solution is simple enough: if they get past 900 points up vertically, we consider them dead and remove them from the fireworks array and from the scene.**

    There is one curious quirk here, and it's down to how you remove items from an array. **When removing items, we're going to loop through the array backwards rather than forwards**. The reason for is that array items move down when you remove an item, so if you have 1, 2, 3, 4 and remove 3 then 4 moves down to become 3. If you're counting forwards, this is a problem because you just checked three and want to move on, but there's now a new 3 and possibly no longer a 4! If you're counting backwards, you just move on to 2.

    ```swift
    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                // this uses a position high above so that rockets can explode off screen
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }
    ```