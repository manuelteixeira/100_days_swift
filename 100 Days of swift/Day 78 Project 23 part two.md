# Day 78 - Project 23, part two

- **Follow the sequence**

    ```swift
    enum SequenceType: CaseIterable {
        case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
    }
    ```

    That **outlines the possible types of ways we can create enemy**: one enemy that definitely is not a bomb, one that might or might not be a bomb, two where one is a bomb and one isn't, then two/three/four random enemies, a chain of enemies, then a fast chain of enemies.

    The **first two will be used exclusively when the player first starts the game, to give them a gentle warm up**. After that, they'll be given random sequence types from **`twoWithOneBomb`** to **`fastChain`**.

    You might have noticed I slipped in a new protocol there: **`CaseIterable`**. This is one of Swift’s most useful protocols, and **it will automatically add an `allCases` property to the `SequenceType` enum that lists all its cases as an array**. This is really useful in our project because we can then use `randomElement()` to pick random sequence types to run our game.

    We're going to need quite a few new properties in order to make the plan work, so please add these now:

    ```swift
    var popupTime = 0.9
    var sequence = [SequenceType]()
    var sequencePosition = 0
    var chainDelay = 3.0
    var nextSequenceQueued = true
    ```

    And here's what they do:

    - The **`popupTime`** property is the amount of time to wait between the last enemy being destroyed and a new one being created.
    - The **`sequence`** property is an array of our **`SequenceType`** enum that defines what enemies to create.
    - The **`sequencePosition`** property is where we are right now in the game.
    - The **`chainDelay`** property is how long to wait before creating a new enemy when the sequence type is **`.chain`** or **`.fastChain`**. Enemy chains don't wait until the previous enemy is offscreen before creating a new one, so it's like throwing five enemies quickly but with a small delay between each one.
    - The **`nextSequenceQueued`** property is used so we know when all the enemies are destroyed and we're ready to create more.

    Whenever we call our new method, which is **`tossEnemies()`**, we're **going to decrease both `popupTime` and `chainDelay` so that the game gets harder as they play**. Sneakily, **we're always going to increase the speed of our physics world, so that objects move rise and fall faster too.**

    Nearly all the **`tossEnemies()`** method **is a large switch/case statement that looks at the `sequencePosition` property to figure out what sequence type it should use**. It **then calls `createEnemy()` correctly for the sequence type, passing in whether to force bomb creation or not.**

    The one thing that will need to be explained is the way enemy chains are created. Unlike regular sequence types, a chain is made up of several enemies with a space between them, and the game doesn't wait for an enemy to be sliced before showing the next thing in the chain.

    ```swift
    func tossEnemies() {
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02

        let sequenceType = sequence[sequencePosition]

        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)

        case .one:
            createEnemy()

        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)

        case .two:
            createEnemy()
            createEnemy()

        case .three:
            createEnemy()
            createEnemy()
            createEnemy()

        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()

        case .chain:
            createEnemy()

            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }

        case .fastChain:
            createEnemy()

            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        }

        sequencePosition += 1
        nextSequenceQueued = false
    }
    ```

    Each sequence in our array creates one or more enemies, then waits for them to be destroyed before continuing. Enemy chains are different: they create five enemies with a short break between, and don't wait for each one to be destroyed before continuing.

    To handle these chains, we have calls to **`asyncAfter()`** with a timer value. If we assume for a moment that **`chainDelay`** is 10 seconds, then:

    - That makes **`chainDelay / 10.0`** equal to 1 second.
    - That makes **`chainDelay / 10.0 * 2`** equal to 2 seconds.
    - That makes **`chainDelay / 10.0 * 3`** equal to three seconds.
    - That makes **`chainDelay / 10.0 * 4`** equal to four seconds.

    So, it spreads out the **`createEnemy()`** calls quite neatly.

    The **`nextSequenceQueued`** property is more complicated. I**f it's `false`, it means we don't have a call to `tossEnemies()` in the pipeline waiting to execute**. **It gets set to `true` only in the gap between the previous sequence item finishing and `tossEnemies()` being called.** Think of it as meaning, "I know there aren't any enemies right now, but more will come shortly."

    We can make our game come to life with enemies with two more pieces of code. First, add this just before the end of **`didMove(to:)`**:

    ```swift
    sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]

    for _ in 0 ... 1000 {
        if let nextSequence = SequenceType.allCases.randomElement() {
            sequence.append(nextSequence)
        }
    }

    DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
        self?.tossEnemies()
    }
    ```

    That code **fills the sequence array with seven pre-written sequences to help players warm up to how the game works**, **then adds 1001** (the ... operator means “up to and including”) **random sequence types to fill up the game**. **Finally, it triggers the initial enemy toss after two seconds**.

    The second change **we're going to make is to remove enemies from the game when they fall off the screen.** **This is required, because our game mechanic means that new enemies aren't created until the previous ones have been removed.** The exception to this rule are enemy chains, where multiple enemies are created in a batch, but even then the game won't continue until all enemies from the chain have been removed.

    We're going to modify the **`update()`** method so that:

    1. **If we have active enemies, we loop through each of them.**
    2. **If any enemy is at or lower than Y position -140, we remove it** from the game and our **`activeEnemies`** array.
    3. **If we don't have any active enemies *and* we haven't already queued the next enemy sequence, we schedule the next enemy sequence and set `nextSequenceQueued` to be true.**

    ```swift
    if activeEnemies.count > 0 {
        for (index, node) in activeEnemies.enumerated().reversed() {
            if node.position.y < -140 {
                node.removeFromParent()
                activeEnemies.remove(at: index)
            }
        }
    } else {
        if !nextSequenceQueued {
            DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) { [weak self] in
                self?.tossEnemies()
            }

            nextSequenceQueued = true
        }
    }
    ```

- **Slice to win**

    We need to modify **`touchesMoved()`** to **detect when users slice penguins and bombs**. The code isn't complicated, but it is long, so I'm going to split it into three. First, here's the structure – place this just before the end of **`touchesMoved()`**:

    ```swift
    let nodesAtPoint = nodes(at: location)

    for case let node as SKSpriteNode in nodesAtPoint {
        if node.name == "enemy" {
            // destroy penguin
        } else if node.name == "bomb" {
            // destroy bomb
        }
    }
    ```

    Now, let's take a look at what **destroying a penguin** should do. It should:

    1. **Create a particle effect over the penguin.**
    2. **Clear its node name so that it can't be swiped repeatedly.**
    3. **Disable the `isDynamic` of its physics body so that it doesn't carry on falling.**
    4. **Make the penguin scale out and fade out at the same time.**
    5. After making the penguin scale out and fade out, we should r**emove it from the scene.**
    6. **Add one to the player's score.**
    7. **Remove the enemy from our `activeEnemies` array.**
    8. **Play a sound** so the player knows they hit the penguin.

    Replace the **`// destroy penguin`** with this, following along with my numbered comments:

    ```swift
    // 1
    if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
        emitter.position = node.position
        addChild(emitter)
    }

    // 2
    node.name = ""

    // 3
    node.physicsBody?.isDynamic = false

    // 4
    let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
    let group = SKAction.group([scaleOut, fadeOut])

    // 5
    let seq = SKAction.sequence([group, .removeFromParent()])
    node.run(seq)

    // 6
    score += 1

    // 7
    if let index = activeEnemies.firstIndex(of: node) {
        activeEnemies.remove(at: index)
    }

    // 8
    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
    ```

    You've now seen the **two ways of collecting SpriteKit actions together**: **groups** and **sequences**. An action **group specifies that all actions inside it should execute simultaneously**, whereas an **action sequence runs them all one at a time**. In the code above we have a group inside a sequence, which is common.

    **If the player swipes a bomb** by accident, they **lose the game immediately.** This uses much the same code as destroying a penguin, but with a few differences:

    - The node called "bomb" is the bomb image, which is inside the bomb container. So, **we need to reference the node's parent when looking up our position**, **changing the physics body**, r**emoving the node from the scene**, and **removing the node from our `activeEnemies` array**.
    - I'm going to **create a different particle effect for bombs than for penguins.**
    - We end by calling the (as yet unwritten) method **`endGame()`**.

    Replace the **`// destroy bomb`** comment with this:

    ```swift
    guard let bombContainer = node.parent as? SKSpriteNode else { continue }

    if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
        emitter.position = bombContainer.position
        addChild(emitter)
    }

    node.name = ""
    bombContainer.physicsBody?.isDynamic = false

    let scaleOut = SKAction.scale(to: 0.001, duration:0.2)
    let fadeOut = SKAction.fadeOut(withDuration: 0.2)
    let group = SKAction.group([scaleOut, fadeOut])

    let seq = SKAction.sequence([group, .removeFromParent()])
    bombContainer.run(seq)

    if let index = activeEnemies.firstIndex(of: bombContainer) {
        activeEnemies.remove(at: index)
    }

    run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
    endGame(triggeredByBomb: true)
    ```

    Before I walk you through the **`endGame()`** method, we need to adjust the **`update()`** method a little. Right now, **if a penguin or a bomb falls below -140, we remove it from the scene.** We're going to modify that so that **if the player misses slicing a penguin, they lose a life.** **We're also going to delete the node's name just in case any further checks for enemies or bombs happen – clearing the node name will avoid any problems.**

    Replace In the **`update()`** method:

    ```swift
    if node.position.y < -140 {
        node.removeAllActions()

        if node.name == "enemy" {
            node.name = ""
            subtractLife()

            node.removeFromParent()
            activeEnemies.remove(at: index)
        } else if node.name == "bombContainer" {
            node.name = ""
            node.removeFromParent()
            activeEnemies.remove(at: index)
        }
    }
    ```

- **Game over, man: SKTexture**

    First is the **`subtractLife()`** method, which **is called when a penguin falls off the screen without being sliced**. It **needs to subtract 1 from the lives property** that we created what seems like years ago, **update the images in the livesImages array so that the correct number are crossed off**, **then end the game if the player is out of lives.**

    ```swift
    func subtractLife() {
        lives -= 1

        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))

        var life: SKSpriteNode

        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }

        life.texture = SKTexture(imageNamed: "sliceLifeGone")

        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration:0.1))
    }
    ```

    Note how I'm using **`SKTexture`** to **modify the contents of a sprite node without having to recreate it.**

    Finally, there's the **`endGame()`** method. I've made this **accept a parameter that sets whether the game ended because of a bomb, so that we can update the UI appropriately.**

    ```swift
    func endGame(triggeredByBomb: Bool) {
        if isGameEnded {
            return
        }

        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false

        bombSoundEffect?.stop()
        bombSoundEffect = nil

        if triggeredByBomb {
            livesImages[0].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[1].texture = SKTexture(imageNamed: "sliceLifeGone")
            livesImages[2].texture = SKTexture(imageNamed: "sliceLifeGone")
        }
    }
    ```

    **If the game hasn't already ended, this code stops every object from moving by adjusting the speed of the physics world to be 0**. **It stops any bomb fuse fizzing, and sets all three lives images to have the same "life gone" graphic.** Nothing surprising in there, but you do need to declare isGameEnded as a property for your class, like this:

    ```swift
    var isGameEnded = false
    ```