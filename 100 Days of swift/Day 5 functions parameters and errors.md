# Day 5 - functions, parameters, and errors

- **Writing functions**

    ```swift
    func printHelp() {
        let message = """
    Welcome to MyApp!

    Test writing functions topic
    """
        print(message)
    }

    printHelp()
    ```

- **Accepting parameters**

    Give each parameter a **name**, **then a colon**, **then** tell Swift **the type** of data it must be.

    ```swift
    func square(number: Int ) {
        print(number * number)
    }

    square(number: 8)
    ```

- **Returning values**

    You use the **return** keyword to send a value back. 

    Your function **immediately exits**, no other code from that function will be run.

    ```swift
    func squareReturningValues(number: Int) -> Int {
        return number * number
    }

    let result = squareReturningValues(number: 8)
    print(result)
    ```

- **Parameter labels**

    Swift lets us provide **two names** for each parameter: 

    - One to be used **externally** when **calling the function**;
    - One to be used **internally** **inside the function**.

    In this example, the **parameter** is called **to name**, which means **externally** it’s **called** **to**, but **internally** it’s **called** **name**.

    ```swift
    func sayHello(to name: String) {
        print("Hello, \(name)!")
    }

    sayHello(to: "Taylor")
    ```

- **Omitting parameter labels**

    We can call functions without having to use a label.

    By using an **underscore _** for your **external** parameter name.

    **Note**: Generally it’s better to give your parameters external names to avoid confusion.

    ```swift
    func greet(_ person: String) {
        print("Hello, \(person)!")
    }

    greet("Taylor")
    ```

- **Default parameters**

    You can give your parameters a **default** **value** **by writing an =** after its type followed by the default you want to give it.

    ```swift
    func greetDefaultParameters(_ person: String, nicely: Bool = true) {
        if nicely == true {
            print("Hello, \(person)!")
        } else {
            print("Oh no, it's \(person) again...")
        }
    }

    greetDefaultParameters("Taylor")
    greetDefaultParameters("Taylor", nicely: false)
    ```

- **Variadic functions**

    Accept **any number** **of parameter**s **of the same type**.

    You can **make** any **parameter** **variadic** by writing **...** after its type.

    Inside the function, **Swift converts the values that were passed** **in to an array**, so you can loop over them as needed.

    ```swift
    func squareVariadic(numbers: Int...) {
        for number in numbers {
            print("\(number) squared is \(number * number)")
        }
    }

    squareVariadic(numbers: 1, 2, 3, 4, 5)
    ```

- **Writing throwing functions**

    We need to **define an enum** **that describes the errors** we can throw. **These must always be based on Swift’s existing Error type.**

    ```swift
    enum PasswordError: Error {
        case obvious
    }

    func checkPassword(_ password: String) throws -> Bool {
        if password == "password" {
            throw PasswordError.obvious
        }
        
        return true
    }
    ```

- **Running throwing functions**

    Swift won’t let you run an error-throwing function by accident.

    You need to call these functions using three keywords: 

    **do** starts a section of code that might cause problems;

    **try** is used before **every** **function** that might throw an error;

    **catch** lets you handle errors gracefully.

    **If any** **errors** **are** **thrown** **inside** the **do** block, **execution** immediately **jumps** to the **catch** block.

    ```swift
    do {
        try checkPassword("password")
        print("That password is good!")
    } catch {
        print("You can't use that password.")
    }
    ```

- **Inout parameters**

    **All parameters** passed into a Swift function **are constants.**

    Parameters as **inout**, means they **can be changed inside your function**, and **those changes reflect in the original value outside the function.**

    **You can’t use constants** with inout, **because they might be changed**. You **also need** **to pass the parameter** **using** an **ampersand &.**

    ```swift
    func doubleInPlace(number: inout Int) {
        number *= 2
    }

    var myNum = 10
    doubleInPlace(number: &myNum)
    ```

## Summary

---

- Functions let us re-use code without repeating ourselves.
- Functions can accept parameters – just tell Swift the type of each parameter.
- Functions can return values, and again you just specify what type will be sent back. Use tuples if you want to return several things.
- **You can use different names for parameters externally and internally**, **or omit the external** name entirely.
- **Parameters can have default values,** which helps you write less code when specific values are common.
- **Variadic functions accept zero or more of a specific parameter**, and **Swift converts the input to an array**.
- **Functions can throw errors**, but you **must call them** **using** **`try`** **and handle errors using** **`catch`**.
- You can use **`inout`** to **change variables inside a function**, but it’s usually better to return a new value.