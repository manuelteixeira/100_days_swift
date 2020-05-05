# Day 2 - arrays, dictionaries, sets, and enums

- **Arrays**

    ```swift
    var str = "Hello, playground"

    let john = "John Lennon"
    let paul = "Paul McCartney"
    let george = "George Harrison"
    let ringo = "Ringo Starr"

    let beatles = [john, paul, george, ringo]
    beatles[1] // Paul McCartney
    ```

- **Sets**

    Don't accept duplicate values.

    Its unordered, so we can't access them using numerical positions.

    ```swift
    let colors = Set(["red", "green", "blue"])
    let colores2 = Set(["red", "green", "blue", "red"])
    ```

- **Tuples**

    Can't add or remove items from a tuple, they are fixed in size.

    Can't change the type of items in a tuple.

    We can access items in a tuple using numerical positions or by naming them.

    Swift won't let you read numbers or names that don't exist.

    ```swift
    var name = (first: "Taylor", last: "Swift")
    name.0
    name.first
    name = (first: "Justin", age: 25) // ERROR
    ```

- **Arrays vs Sets vs Tuples**

    **Tuple:** If you need a **specific, fixed collection** of related values where each item has a **precise position or name.**

    **Set:** If you need a collection of **values that must be unique** or you need to be able to **check whether a specific item is in there extremely quickly.**

    **Array:** If you need a collection of v**alues that can contain duplicates**, or the **order of your items matters**.

    ```swift
    let address = (house: 555, street: "Taylor Swift Avenue", city: "Nashville")
    let set = Set(["aardvark", "astonaut", "azalea"])
    let pythons = ["Eric", "Graham", "John"]
    ```

- **Dictionaries**

    Rather than storing thins with an integer position you can access them using anything you want.

    [**key**: **value**]

    ```swift
    let heights = [
        "Taylor swift": 1.78,
        "Ed Sheeran": 1.73
    ]

    heights["Taylor swift"]
    ```

- **Dictionary default values**

    If you try to read a value using a key that doesn't exist you will get **nil.**

    We can provide a **default value** to use if we request a missing key.

    ```swift
    let favoriteIceCream = [
        "Paul": "Chocolate",
        "Sophie": "Vanilla"
    ]

    favoriteIceCream["Paul"]
    favoriteIceCream["Charlotte"] // nil
    favoriteIceCream["Charlotte", default: "Unknown"] 
    ```

- **Creating empty collections**

    ```swift
    var teams = [String: String]()
    teams["Paul"] = "Red"

    var results = [Int]()

    var words = Set<String>()
    var numbers = Set<Int>()

    // Similar syntax to Sets, but you should use the first ones
    var scores = Dictionary<String, Int>()
    var resultsArray = Array<Int>()
    ```

- **Enumerations**

    Way of defining groups of related values in a way that makes them easier to use.

    This stops you from accidentally using different strings each time.

    ```swift
    let result = "failure"
    let result2 = "failed"
    let result3 = "fail"

    enum Result {
        case success
        case failure
    }

    let result4 = Result.failure
    ```

- **Enum associated values**

    Enums can also store **associated values** to each case.

    Lets you attach additional information to your enums so they can represent more nuanced data.

    ```swift
    enum Activity {
        case bored
        case running(destination: String)
        case talking(topic: String)
        case singing(volume: Int)
    }

    let talking = Activity.talking(topic: "football")
    ```

- **Enum raw values**

    Swift will **automatically** assign each of those a number **starting from 0.**

    You can **assign** one or more cases a **specific value** and **swift will generate the rest**.

    ```swift
    enum Planet: Int {
        case mercury = 1
        case venus
        case earth
        case mars
    }

    let venus = Planet(rawValue: 2)
    ```

## Summary

---

- Arrays, sets, tuples, and dictionaries **let you store a group of items under a single value**. They each do this in different ways, so which you use depends on the behavior you want.
- **Arrays** **store** items in the **order you add them**, and you **access** them **using numerical positions**.
- **Sets** store items **without any order**, so you **can’t access** them **using** **numerical positions**.
- **Tuples** are **fixed in size**, and you **can attach names** **to each of their items**. You **can read** items **using numerical positions** **or** using your **names**.
- **Dictionaries** **store** items **according to a key**, and you **can read** items **using** those **keys**.
- **Enums** are a way of **grouping related values** so you can use them without spelling mistakes.
- You **can** **attach raw values to enums** **so they can be created from integers or strings**, or you **can add associated values** to store additional information about each case.