# Day 8 - structs, properties, and methods

- **Creating your own structs**

    **Variables** **inside** **structs** **are** called **properties.**

    **Properties can have default values** just like regular variables, and you can usually rely on Swift’s type inference.

    ```swift
    struct Sport {
        var name: String
    }

    var tennis = Sport(name: "Tennis")
    print(tennis.name)

    tennis.name = "Lawn tennis"
    ```

- **Computed properties**

    Properties like the **name property** are called **stored properties.**

    **olympicStatus** is a **computed property** – a property that **runs code to figure out its value.**

    Returns different values depending on the other properties.

    ```swift
    struct SportComputed {
        var name: String
        var isOlympicSport: Bool
        
        var olympicStatus: String {
            if isOlympicSport {
                return "\(name) is an Olympic sport"
            } else {
                return "\(name) is not a Olympic sport"
            }
        }
    }

    let chessBoxing = SportComputed(name: "ChessBoxing", isOlympicSport: false)
    print(chessBoxing.olympicStatus)
    ```

- **Property observers**

    Let you **run code before or after any property changes.**

    - **didSet - This will run some code every time the property changes.**
    - **willSet - Take action before a property changes (rarely used).**

    ```swift
    struct Progress {
        var task: String
        var amount: Int {
            didSet {
                print("\(task) is now \(amount) complete")
            }
        }
    }

    var progress = Progress(task: "Loading data", amount: 0)
    progress.amount = 30
    progress.amount = 80
    progress.amount = 100
    ```

- **Methods**

    **Functions inside structs are called** **methods.**

    Because the method belongs to City it can read the current city’s population property.

    That **method belongs to the struct**, so we call it on **instances** of the struct.

    ```swift
    struct City {
        var population: Int
        
        func collectTaxes() -> Int {
            return population * 1000
        }
    }

    let london = City(population: 9_000_000)
    london.collectTaxes()
    ```

- **Mutating methods**

    When you create the struct **Swift has no idea** whether you will **use it with constants or variables.**

    **Swift won’t let you write methods that change properties** **unless you specifically request it.**

    When you want to change a property inside a method, you need to mark it using the mutating keyword

    ```swift
    struct Person {
        var name: String
        
        mutating func makeAnonymous() {
            name = "Anonymous"
        }
    }

    var person = Person(name: "Ed")
    person.makeAnonymous()
    ```

- **Properties and methods of strings**

    **String are structs.**

    They **have** their **own** **methods** **and** **properties** we can use to query and manipulate the string.

    ```swift
    let string = "Do or do not, there is no try."
    print(string.count)
    print(string.hasPrefix("Do"))
    print(string.uppercased())
    print(string.sorted())
    ```

- **Properties and methods of arrays**

    **Arrays are structs.** 

    Which means they too have their own methods and properties

    ```swift
    var toys = ["Woody"]
    print(toys.count)
    toys.append("Buzz")
    print(toys.sorted())
    toys.remove(at: 0)
    ```