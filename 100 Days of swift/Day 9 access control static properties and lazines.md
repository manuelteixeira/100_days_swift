# Day 9 - access control, static properties, and laziness

- **Initializers**

    Initializers are special methods that provide different ways to create your struct.

    All structs come with one by default, called their **memberwise initializer.**

    You do **need** **to make sure all properties have a value before the initializer ends.**

    ```swift
    struct User {
        var username: String
        
        init() {
            username = "Anonymous"
            print("Creating a new user")
        }
    }

    var user = User()
    user.username = "twostraws"
    ```

- **Referring to the current instance**

    Inside methods you get a **special constant called self**, which **points to** whatever **instance of the struct** **is currently being used**.

    Useful when you create initializers that have the same parameter names as your property.

    **self** helps you **distinguish** **between** the **property** **and the parameter**

    ```swift
    struct Person {
        var name: String
        
        init(name: String) {
            self.name = name
            print("\(name) was born")
        }
    }
    ```

- **Lazy properties**

    Swift **will only create the FamilyTree** struct **when it’s first accessed.**

    ```swift
    struct FamilyTree {
        init() {
            print("Creating family tree")
        }
    }

    struct PersonWithFamilyTree {
        var name: String
        lazy var familyTree = FamilyTree()
        
        init(name: String) {
            self.name = name
        }
    }

    var ed = PersonWithFamilyTree(name: "Ed")
    ed.familyTree
    ```

- **Static properties and methods**

    **Static** allows to **share specific properties and methods across all instances of the struct**.

    **classSize** property **belongs to the struct itself** so we need to **read** it **using** **Student.classSize**

    ```swift
    struct Student {
        static var classSize = 0
        var name: String
        
        init(name: String) {
            self.name = name
            Student.classSize += 1
        }
    }

    let eduard = Student(name: "Eduard")
    let taylor = Student(name: "Taylor")
    print(Student.classSize)
    ```

- **Access control**

    You might want to **stop people reading a property directly.** 

    **Can’t read it from outside the struct.**

    Only methods inside Person can read the id property.

    **memberwise initializer cannot initialize private properties. We need to provide a custom init.**

    ```swift
    struct PersonWithId {
        private var id: String
        
        init(id: String) {
            self.id = id
        }
        
        func identify() -> String {
            return "My social security number is \(id)"
        }
    }

    let person = PersonWithId(id: "12345")
    person.identify()
    // person.id - cannot access id property
    ```

## Summary

---

- You can create your own types using structures, which can have their own properties and methods.
- You can use stored properties or use computed properties to calculate values on the fly.
- If you want to change a property inside a method, you must mark it as **`mutating`**.
- Initializers are special methods that create structs. You get a **memberwise initializer by default**, but **if you create your own you must give all properties a value.**
- Use the **`self`** constant to refer to the **current instance** of a struct inside a method.
- The **`lazy`** keyword tells Swift to **create properties only when they are first used.**
- You can **share properties and methods across all instances** of a struct using the **`static`** keyword.
- Access control lets you **restrict what code can use properties and methods.**