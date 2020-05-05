# Day 10 - classes and inheritance

- **Creating your own classes**

    Classes **never come with a memberwise initializer**.

    - if you have properties in your class, you **must always create your own initializer.**

    ```swift
    class Dog {
        var name: String
        var breed: String
        
        init(name: String, breed: String) {
            self.name = name
            self.breed = breed
        }
    }

    let poppy = Dog(name: "Poppy", breed: "Poodle")
    ```

- **Class inheritance**

    You can create a class based on an existing class – it **inherits all the properties and methods** of the original class, and **can add its own** on top.

    ```swift
    class Poddle: Dog {
        init(name: String) {
            super.init(name: name, breed: "Poodle")
        }
    }
    ```

- **Overriding methods**

    **Child classes** **can replace parent methods** with their own implementations – a process known as **overriding**

    ```swift
    class DogOverride {
        func makeNoise() {
            print("Woof")
        }
    }

    class PoddleOverride: DogOverride {
        override func makeNoise() {
            print("Yip")
        }
    }

    let puppy = PoddleOverride()
    puppy.makeNoise()
    ```

- **Final classes**

    When you declare a **class** as being **final, no other class can inherit from it.** 

    This means they **can’t override your methods** in order to change your behavior – they **need to use your class the way it was written.**

    ```swift
    final class DogFinal {
        var name: String
        var breed: String
        
        init(name: String, breed: String) {
            self.name = name
            self.breed = breed
        }
    }
    ```

- **Copying objects**

    When you copy a class **both the original and the copy point to the same object in memory,** so changing one does change the other.

    ```swift
    class Singer {
        var name = "Taylor Swift"
    }

    var singer = Singer()
    print(singer.name)

    var singerCopy = singer
    singerCopy.name = "Justin Bieber"

    print(singerCopy.name)
    print(singer.name)
    ```

- **Deinitializers**

    Code that gets run when an **instance** of a class is **destroyed**.

    ```swift
    class Person {
        var name = "John Doe"
        
        init() {
            print("\(name) is alive")
        }
        
        func printGreeting() {
            print("Hello, I'm \(name)")
        }
        
        deinit {
            print("\(name) is no more!")
        }
    }

    for _ in 1...3 {
        let person = Person()
        person.printGreeting()
    }
    ```

- **Mutability**

    If you have a **constant struct with a variable property**, **that property can’t be changed** because the struct itself is constant.

    if you have a **constant class with a variable property, that property can be changed**. Because of this, **classes** **don’t need the mutating keyword** with methods that change properties.

    If you want to **stop** **that from happening** you **need** to **make** the **property** **constant.**

    ```swift
    class SingerMutability {
        var name = "Taylor Swift"
    }

    let taylor = SingerMutability()
    taylor.name = "Ed Sheeran"
    print(taylor.name)
    ```

## Summary

---

- Classes and structs are similar, in that they can both let you create your own types with properties and methods.
- One class can inherit from another, and it gains all the properties and methods of the parent class. It’s common to talk about class hierarchies – one class based on another, which itself is based on another.
- You can mark a class with the **`final`** keyword, which **stops other classes from inheriting from it.**
- **Method overriding** lets a **child** class **replace** a **method** in its parent class with a new implementation.
- When **two variables point at the same class instance, they both point at the same piece of memory – c**hanging one changes the other.
- Classes can have a **deinitializer**, which is **code that gets run when an instance of the class is destroyed.**
- Classes don’t enforce constants as strongly as structs – if a property is declared as a variable, it can be changed regardless of how the class instance was created.