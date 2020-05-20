# Day 45 - Project 11, part one

- **Falling boxes: SKSpriteNode, UITouch, SKPhysicsBody**

    While you’re in the scene editor. With the scene selected, look in the attributes inspector for **Anchor Point**. This **determines what coordinates SpriteKit uses to position children** and **it’s X:0.5 Y:0.5 by default.**

    **This is different to UIKit**: it means “**position me based on my center**”, whereas **UIKit positions things based on their top-left corner**. **Anchor point should 0 for both X and Y.**

    **Note**: **SpriteKit considers Y:0 to be the bottom of the screen whereas UIKit considers it to be the top**

    Change the size of the scene to 1024x768 to match iPad landscape size.

    **If you want to place an image in your game**, the class to use is called **`SKSpriteNode`**, and **it can load any picture from your app bundle just like `UIImage`.**

    To place a background image, **we need to load the file called background.jpg, then position it in the center of the screen**. 

    SpriteKit positions things based on their center – i.e., **the point 0,0 refers to the horizontal and vertical center of a node**. And also unlike UIKit, SpriteKit's **Y axis starts at the bottom edge, so a higher Y number places a node higher on the screen.** 

    So, to place the background image in the center of a landscape iPad, we need to place it at the position X:512, Y:384.

    First, we're going to **give it the blend mode `.replace`**. 

    **Blend modes determine how a node is drawn**, and SpriteKit gives you many options. The **`.replace`** option **means "just draw it, ignoring any alpha values,"** which makes it fast for things without gaps such as our background. We're also going to **give the background a `zPosition` of `-1`, which in our game means "draw this behind everything else."**

    **To add any node to the current screen, you use the `addChild()` method.**

    Add this code to the **`didMove(to:)`** method, which is **sort of the equivalent of SpriteKit's `viewDidLoad()` method**:

    ```swift
    let background = SKSpriteNode(imageNamed: "background.jpg")
    background.position = CGPoint(x: 512, y: 384)
    background.blendMode = .replace
    background.zPosition = -1
    addChild(background)
    ```

    Let's do something a bit more interesting, so add this to the **`touchesBegan()`** method:

    ```swift
    if let touch = touches.first {
        let location = touch.location(in: self)
        let box = SKSpriteNode(color: UIColor.red, size: CGSize(width: 64, height: 64))
        box.position = location
        addChild(box)
    }
    ```

    This **method gets called** (in UIKit and SpriteKit) **whenever someone starts touching their device.**

    **It's possible they started touching with multiple fingers at the same time**, **so we get passed a new data type called `Set`**. 

    This is just **like an array, except each object can appear only once.**

    **We want to know where the screen was touched**, so **we use a conditional typecast** **plus** **`if let`** to **pull out any of the screen touches from the touches set,** then use its **`location(in:)`** method **to find out where the screen was touched in relation to self** - i.e., the game scene. 

    **`UITouch`** is a **`UIKit`** class that is also used in **`SpriteKit`**, and **provides information about a touch such as its position and when it happened.**

    **`SKSpriteNode`** so **this line generates a node filled with a color** (red) **at a size** (64x64). The **`CGSize`** **it just holds a width and a height in a single structure.**

    Just before setting the position of our new box, add this line:

    ```swift
    box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 64, height: 64))
    ```

    **Adds a physics body to the box that is a rectangle of the same size as the box.** 

    And just before the end of **`didMove(to:)`**, add this:

    ```swift
    physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    ```

    **Adds a physics body to the whole scene that is a line on each edge, effectively acting like a container for the scene**.

- **Bouncing balls: circleOfRadius**

    Take the box code out and replace it with this instead:

    ```swift
    let ball = SKSpriteNode(imageNamed: "ballRed")
    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
    ball.physicsBody?.restitution = 0.4
    ball.position = location
    addChild(ball)
    ```

    First, **we're using the `circleOfRadius` initializer for `SKPhysicsBody` to add circular physics to this ball**. 

    Second, **we're giving the ball's physics body a restitution (bounciness) level of `0.4`,** where **values are from `0` to `1`**.

    **Note:** the physics body of a node is optional, because it might not exist. We know it exists because we just created it, so it’s not uncommon to see physicsBody! to force unwrap the optional.

    Just before the end of the **`didMove(to:)`** method, add this:

    ```swift
    let bouncer = SKSpriteNode(imageNamed: "bouncer")
    bouncer.position = CGPoint(x: 512, y: 0)
    bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
    bouncer.physicsBody?.isDynamic = false
    addChild(bouncer)
    ```

    **`CGPoint`** it just **holds X/Y co-ordinates**. Remember, SpriteKit's positions start from the center of nodes, so **X:512 Y:0 means "centered horizontally on the bottom edge of the scene."**

    **`isDynamic`** property of a physics body. **When** this is **`true`**, **the object will be moved by the physics simulator based on gravity and collisions**. **When** it's **`false`** the **object will still collide with other things, but it won't ever be moved as a result.**

    Create a function for creating a bouncer at a **`CGPoint`**

    ```swift
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    ```

    To show this off, delete the bouncer code from **`didMove(to:)`**, and replace it with this:

    ```swift
    makeBouncer(at: CGPoint(x: 0, y: 0))
    makeBouncer(at: CGPoint(x: 256, y: 0))
    makeBouncer(at: CGPoint(x: 512, y: 0))
    makeBouncer(at: CGPoint(x: 768, y: 0))
    makeBouncer(at: CGPoint(x: 1024, y: 0))
    ```