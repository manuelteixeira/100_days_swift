# Day 11 - protocols, extensions, and protocol extensions

- **Protocols**

    Protocols are a way of describing **what properties and methods something must have.**

    ```swift
    protocol Identifiable {
        var id: String { get set }
    }

    struct User: Identifiable {
        var id: String
    }

    func displayID(thing: Identifiable) {
        print("My ID is \(thing.id)")
    }
    ```

- **Protocol inheritance**

    One protocol can **inherit** from **multiple protocols** in a process known as **protocol inheritance**.

    Now we can make new types conform to that single protocol rather than each of the three individual ones.

    ```swift
    protocol Payable {
        func calculateWages() -> Int
    }

    protocol NeedsTraining {
        func study()
    }

    protocol HasVacation {
        func takeVacation(days: Int)
    }

    protocol Employee: Payable, NeedsTraining, HasVacation {}
    ```

- **Extensions**

    Extensions **allow you to add methods to existing types**, to make them do things they weren’t originally designed to do.

    Swift **doesn’t let you add stored properties in extensions**, so **you** **must** **use computed properties** instead.

    ```swift
    extension Int {
        func squared() -> Int {
            return self * self
        }
    }

    let number = 8
    number.squared()

    extension Int {
        var isEven: Bool {
            return self % 2 == 0
        }
    }

    number.isEven
    ```

- **Protocol extensions**

    Protocols **let you describe what methods** something should have, **but don’t provide the code inside.**

    Extensions **let you provide the code inside your methods**, **but only affect one data type** – you **can’t add the method to lots of types at the same time.**

    **Protocol extensions solve both those problems.**

    **They are like regular extensions**, except rather than extending a specific type like Int you **extend a whole protocol** so that **all conforming types get your changes.**

    ```swift
    let pythons = ["Eric", "Graham", "John", "Michael", "Terry", "Terry"]
    let beatles = Set(["John", "Paul", "George", "Ringo"])

    extension Collection {
        func summarize() {
            print("There are \(count) of us")
            
            for name in self {
                print(name)
            }
        }
    }

    pythons.summarize()
    beatles.summarize()
    ```

- **Protocol-oriented programming**

    Protocol extensions **can provide default implementations** **for** our own **protocol methods**.

    ```swift
    protocol IdentifiablePOP {
        var id: String { get set }
        func identify()
    }

    extension IdentifiablePOP {
        func identify() {
            print("My ID is \(id)")
        }
    }

    struct UserPOP: IdentifiablePOP {
        var id: String
    }

    let twostraws = UserPOP(id: "twostraws")
    twostraws.identify()
    ```

## Summary

---

- Protocols describe what methods and properties a conforming type must have, but don’t provide the implementations of those methods.
- You can build protocols on top of other protocols, similar to classes.
- Extensions let you add methods and computed properties to specific types such as **`Int`**.
- Protocol extensions let you add methods and computed properties to protocols.
- Protocol-oriented programming is the practice of designing your app architecture as a series of protocols, then using protocol extensions to provide default method implementations.