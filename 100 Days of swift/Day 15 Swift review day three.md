# Day 15 - Swift review, day three

- **Properties**

    **Property observers.**

    Swift lets you add code to be run **when a property is about to be changed or has been changed.**

    Two kinds of property observer: **`willSet`** and **`didSet`.**

    **`willSet`** provides your code with a special value called **`newValue`** that contains what the **new property value is going to be.**

    **`didSet`** you are given **`oldValue`** to **represent the previous value.**

    ```swift
    struct Person {
        var clothes: String {
            willSet {
                updateUI(msg: "I'm changing from \(clothes) to \(newValue)")
            }

            didSet {
                updateUI(msg: "I just changed from \(oldValue) to \(clothes)")
            }
        }
    }

    func updateUI(msg: String) {
        print(msg)
    }

    var taylor = Person(clothes: "T-shirts")
    taylor.clothes = "short skirts"
    ```

    **Computed properties.**

    Make properties that **are actually code** behind the scenes.

    Place an **open brace after your property** **then** use either **`get`** **or** **`set`** **to make an action happen at the appropriate time.**

    ```swift
    struct Person {
        var age: Int

        var ageInDogYears: Int {
            get {
                return age * 7
            }
        }
    }

    var fan = Person(age: 25)
    print(fan.ageInDogYears)
    ```

    If **you intend to use them only for reading data** you can just **remove** the **`get`** part entirely.

    ```swift
    var ageInDogYears: Int {
        return age * 7
    }
    ```

- **Static properties and methods**

    Swift lets you **create properties and methods that belong to a type**, rather than to instances of a type.

    Helpful for organizing your data meaningfully by **storing shared data.**

    ```swift
    struct TaylorFan {
        static var favoriteSong = "Look What You Made Me Do"

        var name: String
        var age: Int
    }

    let fan = TaylorFan(name: "James", age: 25)
    print(TaylorFan.favoriteSong)
    ```

- **Access control**
    - **Public**

        this means **everyone can read and write the property**.

    - **Internal**

        this means **only your Swift code can read and write the property**. **If you ship your code as a framework** for others to use, **they won’t be able to read the property.**

    - **File Private**

        this means that **only Swift code in the same file as the type** can read and write the property.

    - **Private**

        this is the **most restrictive** option, and means the property is **available only inside methods that belong to the type, or its extensions.**

    ```swift
    class TaylorFan {
        private var name: String?
    }
    ```

- **Polymorphism and typecasting**

    Because any instance of **`LiveAlbum`** is inherited from **`Album`** it can be treated just as either **`Album`** or **`LiveAlbum`** – it's both at the same time. This is called "**polymorphism**"

    ```swift
    class Album {
        var name: String

        init(name: String) {
            self.name = name
        }

        func getPerformance() -> String {
            return "The album \(name) sold lots"
        }
    }

    class StudioAlbum: Album {
        var studio: String

        init(name: String, studio: String) {
            self.studio = studio
            super.init(name: name)
        }

        override func getPerformance() -> String {
            return "The studio album \(name) sold lots"
        }
    }

    class LiveAlbum: Album {
        var location: String

        init(name: String, location: String) {
            self.location = location
            super.init(name: name)
        }

        override func getPerformance() -> String {
            return "The live album \(name) sold lots"
        }
    }
    ```

    The **`getPerformance()`** method exists in the **`Album`** class, but both child classes override it.

    That will automatically use the override version of **`getPerformance()`** **depending on the subclass in question**. That's **polymorphism** in action: **an object can work as its class and its parent classes**, all **at the same time.**

    ```swift
    var taylorSwift = StudioAlbum(name: "Taylor Swift", studio: "The Castles Studios")
    var fearless = StudioAlbum(name: "Speak Now", studio: "Aimeeland Studio")
    var iTunesLive = LiveAlbum(name: "iTunes Live from SoHo", location: "New York")

    var allAlbums: [Album] = [taylorSwift, fearless, iTunesLive]

    for album in allAlbums {
        print(album.getPerformance())
    }
    ```

    **Converting types with typecasting.**

    You will often find you have an object of a certain type, but really you know it's a different type.

    Solution, and it's called **typecasting**: **converting an object of one type to another.**

    **`as?`** - **optional downcasting**

    "I think this conversion might be true, but it might fail"

    **`as!` - forced downcasting**

    "I know this conversion is true, and I'm happy for my app to crash if I'm wrong."

    ```swift
    for album in allAlbums {
        print(album.getPerformance())

        if let studioAlbum = album as? StudioAlbum {
            print(studioAlbum.studio)
        } else if let liveAlbum = album as? LiveAlbum {
            print(liveAlbum.location)
        }
    }
    ```

    Swift will make **`studioAlbum`** have the data type **`StudioAlbum?`**.

    the conversion **might have worked**, in **which case you have a studio album** you can work with, **or it might have failed**, in which case you **have nil**.

    If you wanted to **write that forced downcast at the array level.**

    That no longer needs to downcast every item inside the loop, because it happens when the loop begins.

    ```swift
    for album in allAlbums as! [StudioAlbum] {
        print(album.studio)
    }
    ```

    Swift also allows **optional downcasting** at the array level, although it's a bit more tricksy because **you need to use the nil coalescing operator to ensure there's always a value for the loop.**

    that means is, “try to convert **`allAlbums`** to be an array of **`LiveAlbum`** objects, but **if that fails just create an empty array** of live albums and use that instead” – i.e., **do nothing.**

    ```swift
    for album in allAlbums as? [LiveAlbum] ?? [LiveAlbum]() {
        print(album.location)
    }
    ```

- **Closures**

    A closure can be thought of as a **variable that holds code.**

    They **take a copy of the values that are used inside them.**

    I declared the **`vw`** constant **outside of the closure**, **then used it inside.** Swift detects this, and **makes that data available inside the closure too.**

    ```swift
    let vw = UIView()

    UIView.animate(withDuration: 0.5, animations: {
        vw.alpha = 0
    })
    ```

    Trailing closures

    The rule is this: i**f the last parameter to a method takes a closure**, **you can eliminate that parameter** **and** instead **provide** it **as a block of code inside braces**.

    ```swift
    let vw = UIView()

    UIView.animate(withDuration: 0.5) {
        vw.alpha = 0
    }
    ```