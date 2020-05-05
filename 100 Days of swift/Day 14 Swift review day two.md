# Day 14 - Swift review, day two

- **Functions**

    Functions let you **define re-usable pieces of code that perform specific pieces of functionality.**

    ```swift
    func printAlbumRelease(name: String, year: Int) {
        print("\(name) was released in \(year)")
    }

    printAlbumRelease(name: "Fearless", year: 2008)
    ```

    **External and internal parameter names.**

    Swift’s solution is to let you specify **one name for the parameter when it’s being called**, **and another inside the method.**

    You can also specify an **underscore, _,** **as the external parameter name,** which tells Swift that **it shouldn’t have any external name at all.**

    ```swift
    func countLetters(in string: String) {
        print("The string \(string) has \(string.count) letters.")
    }

    countLetters(in: "Hello")
    ```

    **Return values**

    Swift functions **can return a value** by writing **-> then a data type after their parameter list.**

    Swift will ensure that your function will return a value no matter what

    ```swift
    func albumIsTaylor(name: String) -> Bool {
        if name == "Taylor Swift" { return true }
        if name == "Fearless" { return true }
        if name == "Speak Now" { return true }
        if name == "Red" { return true }
        if name == "1989" { return true }

        return false
    }

    if albumIsTaylor(name: "Red") {
        print("That's one of hers!")
    } else {
        print("Who made that?!")
    }
    ```

- **Optionals**

    In Swift, this "**no value**" has a special name: **`nil`**.

    ```swift
    func getHaterStatus(weather: String) -> String? {
        if weather == "sunny" {
            return nil
        } else {
            return "Hate"
        }
    }
    ```

    **optional unwrapping**, and it's **done inside a conditional statement using special syntax**. 

    It does two things at the same time:

    **checks whether an optional has a value;** 

    if so **unwraps** **it into a non-optional type then runs a code block**.

    ```swift
    if let unwrappedStatus = status {
        // unwrappedStatus contains a non-optional value!
    } else {
        // in case you want an else block, here you go…
    }
    ```

    **Force unwrapping optionals**

    Swift lets you override its safety by using the exclamation mark character: **`!`**.

    **If you try this on a variable that does not have a value, your code will crash.**

    ```swift
    func yearAlbumReleased(name: String) -> Int? {
        if name == "Taylor Swift" { return 2006 }
        if name == "Fearless" { return 2008 }
        if name == "Speak Now" { return 2010 }
        if name == "Red" { return 2012 }
        if name == "1989" { return 2014 }

        return nil
    }

    var year = yearAlbumReleased(name: "Red")
    print("It was released in \(year!)")
    ```

    **Implicitly unwrapped optionals.**

    **Might contain a value**, or might not. **But it does not need to be unwrapped before it is used.**

    ```swift
    var name: String! = "Bob"
    ```

    The main times you're going to meet implicitly unwrapped optionals is when you're working with user interface elements in UIKit on iOS or AppKit on macOS. These need to be declared up front, but you can't use them until they have been created – and Apple likes to create user interface elements at the last possible moment to avoid any unnecessary work.

- **Optional chaining**

    **Optional chaining**, which **lets you run code only if your optional has a value.**

    Everything after the question mark will only be run if everything before the question mark has a value.

    ```swift
    func albumReleased(year: Int) -> String? {
        switch year {
        case 2006: return "Taylor Swift"
        case 2008: return "Fearless"
        case 2010: return "Speak Now"
        case 2012: return "Red"
        case 2014: return "1989"
        default: return nil
        }
    }

    let album = albumReleased(year: 2006)?.uppercased()
    print("The album is \(album)")
    ```

    **The nil coalescing operator.**

    Use value **A** **if you can, but if value A is nil then use value B.**

    ```swift
    let album = albumReleased(year: 2006) ?? "unknown"
    print("The album is \(album)")
    ```

    it means "if albumReleased() returned a value then put it into the album variable, but if albumReleased() returned nil then use 'unknown' instead."

- **Enumerations**

    Are a way for you to **define your own kind of value** in Swift.

    ```swift
    enum WeatherType {
        case sun, cloud, rain, wind, snow
    }

    func getHaterStatus(weather: WeatherType) -> String? {
        if weather == WeatherType.sun {
            return nil
        } else {
            return "Hate"
        }
    }

    getHaterStatus(weather: WeatherType.cloud)
    ```

    **Enums with additional values.**

    Enumerations can have values attached to them that you define.

    ```swift
    enum WeatherType {
        case sun
        case cloud
        case rain
        case wind(speed: Int)
        case snow
    }
    ```

    Swift **lets us add extra conditions to the switch/case block** so that a case will match only if those conditions are true.

    This uses the **`let`** keyword to **access the value inside a case**, then the `**where**` keyword for **pattern matching.**

    ```swift
    func getHaterStatus(weather: WeatherType) -> String? {
        switch weather {
        case .sun:
            return nil
        case .wind(let speed) where speed < 10:
            return "meh"
        case .cloud, .wind:
            return "dislike"
        case .rain, .snow:
            return "hate"
        }
    }

    getHaterStatus(weather: WeatherType.wind(speed: 5))
    ```

    Swift **evaluates switch/case from top to bottom,** **and stops as soon as it finds a match.** 

    This means that if `**case .cloud, .wind:**` **appears** **before** **`case .wind(let speed) where speed < 10:`** **then it will be executed instead** – and the output changes.

    **Carefully about how you order cases!**

- **Structs**

    Swift it automatically generates a **memberwise initializer.**

    You create the struct by passing in initial values for its two properties.

    ```swift
    struct Person {
        var clothes: String
        var shoes: String
    }
    ```

    You can read its properties just by writing the name of the struct, a period, then the property you want to read:

    ```swift
    print(taylor.clothes)
    print(other.shoes)
    ```

    **If you assign one struct to another**, **Swift copies** it behind the scenes **so that it is a complete, standalone duplicate of the original**. Well, that's not strictly true: Swift uses a technique called "copy on write" which means it only actually copies your data if you try to change it.

    ```swift
    let taylor = Person(clothes: "T-shirts", shoes: "sneakers")
    let other = Person(clothes: "short skirts", shoes: "high heels")

    var taylorCopy = taylor
    taylorCopy.shoes = "flip flops"

    print(taylor)
    print(taylorCopy)
    ```

- **Classes**

    They look similar to structs, but have a number of **important differences**, including:

    - You **don't get an automatic memberwise initializer** for your classes; **you need to write your own**.
    - You **can define a class as being based off another class**, adding any new things you want.
    - When you **create an instance of a class it’s called an object**. **If you copy that object**, **both copies point at the same data** by default – **change one, and the copy changes too**.

    **Initializing an object.**

    ```swift
    class Person {
        var clothes: String
        var shoes: String

        init(clothes: String, shoes: String) {
            self.clothes = clothes
            self.shoes = shoes
        }
    }
    ```

    **Class inheritance.**

    ```swift
    class Singer {
        var name: String
        var age: Int

        init(name: String, age: Int) {
            self.name = name
            self.age = age
        }

        func sing() {
            print("La la la la")
        }
    }
    ```

    `**override**`. This means "I know this method was implemented by my parent class, but I want to change it for this subclass."

    ```swift
    class CountrySinger: Singer {
        override func sing() {
            print("Trucks, guitars, and liquor")
        }
    }
    ```

    We are going to create a new class called **`HeavyMetalSinger`**. But this time we're going to store a new property called **`noiseLevel`.**

    This causes a problem, and it's one that needs to be solved in a very particular way:

    - Swift wants all non-optional properties to have a value.
    - Our **`Singer`** class doesn't have a **`noiseLevel`** property.
    - So, we need to create a custom initializer for **`HeavyMetalSinger`** that accepts a noise level.
    - That new initializer also needs to know the **`name`** and **`age`** of the heavy metal singer, so it can pass it onto the superclass **`Singer`**.
    - Passing on data to the superclass is done through a method call, and you can't make method calls in initializers until you have given all your properties values.
    - So, we need to set our own property first (**`noiseLevel`**) then pass on the other parameters for the superclass to use.

    initializer takes three parameters, then calls **`super.init()`** to pass **`name`** and **`age`** on to the Singer superclass - **but only after its own property has been set.**

    ```swift
    class HeavyMetalSinger: Singer {
        var noiseLevel: Int

        init(name: String, age: Int, noiseLevel: Int) {
            self.noiseLevel = noiseLevel
            super.init(name: name, age: age)
        }

        override func sing() {
            print("Grrrrr rargh rargh rarrrrgh!")
        }
    }
    ```

    **Working with Objective-C code.**

    If you want to have some part of Apple’s operating system call your Swift class’s method, you need to mark it with a special attribute: **`@objc`**.

    Attribute effectively **marks the method as being available for older Objective-C** code to run.

    You can put **`@objcMembers`** before **your** **class** to **automatically make all its methods available to Objective-C.**

- **Values vs References**

    When you **copy a struct**, **the whole thing is duplicated**, including all its values. 

    This means that **changing one copy of a struct doesn't change the other** copies – they are all individual. 

    With **classes**, **each copy of an object points at the same original object**, so if you **change one they all change**. 

    Swift calls **structs "value types" because they just point at a value**, 

    **Classes "reference types"** because **objects are just shared references** **to the real value.**

    This is an important difference, and it means the **choice between structs and classes** is an important one:

    - If you want to have **one shared state that gets passed around and modified in place**, you're looking for **classes**. You can pass them into functions or store them in arrays, modify them in there, and have that change reflected in the rest of your program.
    - If you want to **avoid shared state where one copy can't affect all the others**, you're looking for **structs**. You can pass them into functions or store them in arrays, modify them in there, and they won't change wherever else they are referenced.

    If I were to summarize this key difference between structs and classes, I'd say this: 

    **classes offer more flexibility**, 

    **structs offer more safety**. 

    As a **basic rule, you should always use structs until you have a specific reason to use classes.**