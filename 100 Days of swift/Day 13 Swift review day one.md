# Day 13 - Swift review, day one

- **Variables and constants**

    **Variable** is a data store that **can have its value changed** whenever you want.

    **Constant** is a data store that you **set once and can never change.**

    Constants are also important because they let Xcode make decisions about the way it builds your app. If it knows a value will never change, it is able to apply optimizations to make your code run faster.

    ```swift
    var name = "Tim"
    name = "Romeo"

    let nameConstant = "Tim"
    nameConstant = "Romeo" // Error

    var sameName = "Tim"
    var sameName = "Romeo" // Error
    ```

- **Types of Data**

    Swift knows that **name** **should hold a string** **because you assign a string** to it when you create it: "Tim McGraw".

    ```swift
    var name = "Tim McGraw" // Prefered way

    var nameType: String
    nameType = "Tim"
    ```

    **Float and Double**

    Official Apple recommendation is **always to use Double** because it has the highest accuracy.

    **Double has twice the accuracy of Float.**

- **Operators**

    + to add

    - to subtract 

    * to multiply

    / to divide

    = to assign

    += is an operator that means "add then assign to."

    ```swift
    var b = 10
    b += 10
    b -= 10
    ```

    When it comes to strings, + will join them together.

    ```swift
    var name1 = "Tim McGraw"
    var name2 = "Romeo"
    var both = name1 + " and " + name2
    ```

    %. It means “divide the left hand number evenly by the right, and return the remainder.”

    Swift has a set of **operators** that **perform comparisons on values.**

    ```swift
    c > 3
    c >= 3
    c > 4
    c < 4
    ```

    ==, meaning "is equal to."

    ```swift
    var name = "Tim McGraw"
    name == "Tim McGraw"
    ```

    "not" operator: !

    This makes your statement mean the opposite of what it did.

    ```swift
    var stayOutTooLate = true
    stayOutTooLate // true
    !stayOutTooLate // false
    ```

    You can also use ! with = to make != or "not equal".

    ```swift
    var name = "Tim McGraw"
    name == "Tim McGraw"
    name != "Tim McGraw"
    ```

- **String interpolation**

    Combining **variables** **and** **constants** **inside** **a** **string**.

    String interpolation in Swift is smart enough to be able to **handle a variety of different data types automatically.**

    You can do mathematics in there using operators

    ```swift
    var nameInterpolation = "Tim McGraw"
    var age = 25
    var latitude = 36.166667

    "Your name is \(nameInterpolation), your age is \(age), and your latitude is \(latitude)"

    "You are \(age) years old. In another \(age) years you will be \(age * 2)."
    ```

- **Arrays**

    **Arrays** let you **group lots of values together into a single collection**, then **access those values by their position** in the collection.

    Our array **has** **three** items in, **which means indexes 0, 1 and 2** work great. But **if you try and read songs[3]** will crash.

    ```swift
    var evenNumbers = [2, 4, 6, 8]
    var songs = ["Shake it Off", "You Belong with Me", "Back to December"]

    songs[0]
    songs[1]
    songs[2]
    ```

    Creating arrays

    ```swift
    var songs: [String] = []
    // OR
    var songs = [String]()
    ```

    Array operators

    You can use a limited set of operators on arrays. For example, you can **merge two arrays by using the +** operator.

    ```swift
    var songs = ["Shake it Off", "You Belong with Me", "Love Story"]
    var songs2 = ["Today was a Fairytale", "Welcome to New York", "Fifteen"]
    var both = songs + songs2
    ```

    You can also use **+= to add and assign**, like this:

    ```swift
    both += ["Everything has Changed"]
    ```

- **Dictionaries**

    You get to **read and write values using a key** you specify.

    ```swift
    var person = [
                    "first": "Taylor",
                    "middle": "Alison",
                    "last": "Swift",
                    "month": "December",
                    "website": "taylorswift.com"
                ]

    person["middle"]
    person["month"]
    ```

- **Conditional statements**

    That **will check each condition in order,** and **only one** of the blocks **will** **be** **executed**.

    ```swift
    var action: String
    var person = "hater"

    if person == "hater" {
        action = "hate"
    } else if person == "player" {
        action = "play"
    } else {
        action = "cruise"
    }
    ```

    To **check multiple conditions**, use the **&&** operator – it means "and".

    Swift uses something called **short-circuit evaluation** to boost performance: **if it is evaluating multiple things that all need to be true, and the first one is false, it doesn't even bother evaluating the rest.**

    ```swift
    var action: String
    var stayOutTooLate = true
    var nothingInBrain = true

    if stayOutTooLate && nothingInBrain {
        action = "cruise"
    }
    ```

- **Loops**

    **closed range operator. (1...10)**

    What the loop does is count from 1 to 10 (including 1 and 10).

    ```swift
    for i in 1...10 {
        print("\(i) x 10 is \(i * 10)")
    }
    ```

    If you don't need to know what number you're on, you can use an **underscore** instead.

    ```swift
    var str = "Fakers gonna"

    for _ in 1 ... 5 {
        str += " fake"
    }

    print(str)
    ```

    **half open range operator (1..<5)** 

    And counts **from one number** up to and **excluding another**. 

    This will count 1, 2, 3, 4.

    Because Swift already knows what kind of data your array holds, it will go through every element in the array, assign it to a constant you name, then run a block of your code.

    ```swift
    var songs = ["Shake it Off", "You Belong with Me", "Look What You Made Me Do"]

    for song in songs {
        print("My favorite song is \(song)")
    }
    ```

    **While loops**

    Which **repeats a block of code until you tell it to stop**.

    **break -** It's used to **exit a while or for loop** at a point you decide.

    **continue -** only **exits the current iteration of the loop** – it will jump back to the top of the loop and pick up from there.

    ```swift
    var counter = 0

    while true {
        print("Counter is now \(counter)")
        counter += 1

        if counter == 556 {
            break
        }
    }
    ```

- **Switch case**

    You tell Swift **what variable you want to check**, **then provide a list of possible cases for that variable.**

    Swift will **find the first case that matches your variable**, then run its block of code.

    When that **block finishes, Swift exits** the whole switch/case block.

    One advantage to switch/case **is that Swift will ensure your cases are exhaustive.**

    ```swift
    let liveAlbums = 2

    switch liveAlbums {
    case 0:
        print("You're just starting out")

    case 1:
        print("You just released iTunes Live From SoHo")

    case 2:
        print("You just released Speak Now World Tour")

    default:
        print("Have you done something new?")
    }
    ```

    If you wanted to check for a range of possible values, you could use the closed range operator.

    You use the **fallthrough** keyword **to make one case fall into the next.**

    ```swift
    let studioAlbums = 5

    switch studioAlbums {
    case 0...1:
        print("You're just starting out")

    case 2...3:
        print("You're a rising star")

    case 4...5:
        print("You're world famous!")

    default:
        print("Have you done something new?")
    }
    ```