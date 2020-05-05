# Day 7 - Closures, part two

- **Using closures as parameters when they accept parameters**

    We can write a travel() function that **accepts a closure** **as** its only **parameter**, **and that closure** in turn **accepts** **a string.**

    ```swift
    func travel(action: (String) -> Void) {
        print("I'm getting ready to go.")
        action("London")
        print("I arrived")
    }

    travel { (place: String) in
        print("I'm going to \(place) in my car")
    }
    ```

- **Using closures as parameters when they return values**

    We can write a travel() function that **accepts a closure as its only parameter,** and **that closure** in turn accepts a **string and returns a string.**

    ```swift
    func travelWithReturnClosure(action: (String) -> String) {
        print("I'm getting ready to go.")
        let description = action("London")
        print(description)
        print("I arrived")
    } 

    travelWithReturnClosure { (place: String) -> String in
        return "I'm going to \(place) in my car."
    }
    ```

- **Shorthand parameter names**

    ```swift
    func travelWithReturnClosure(action: (String) -> String) {
        print("I'm getting ready to go.")
        let description = action("London")
        print(description)
        print("I arrived")
    }

    travelWithReturnClosure { (place: String) -> String in
        return "I'm going to \(place) in my car"
    }
    ```

    **Swift knows the parameter to that closure must be a string,** so we can remove it

    ```swift
    travelWithReturnClosure { place -> String in
        return "I'm going to \(place) in my car"
    }
    ```

    It **also knows the closure must return a string**, so we can remove that:

    ```swift
    travelWithReturnClosure { place in
        return "I'm going to \(place) in my car"
    }
    ```

    **As the closure only has one line of code** **that must be the one that returns the value**, so Swift lets us remove the return keyword too:

    ```swift
    travelWithReturnClosure { place in
        "I'm going to \(place) in my car"
    }
    ```

    We can let **Swift provide automatic names** for the closure’s **parameters**.

    ```swift
    travelWithReturnClosure {
        return "I'm going to \($0) in my car."
    }
    ```

- **Closures with multiple parameters**

    Because this accepts **two parameters**, we’ll be getting both **$0** and **$1**

    ```swift
    func travelWithMultipleParams(action: (String, Int) -> String) {
        print("I'm getting ready to go.")
        let description = action("London", 60)
        print(description)
        print("I arrived")
    } 

    travelWithMultipleParams { 
        "I'm going to \($0) at \($1) miles per hour."
    }
    ```

- **Returning closures from functions**

    You can **get closures returned from a function**.

    It uses **-> twice**: 

    **Specify your function’s return value.**

    **Specify your closure’s return value.**

    We can now call travelReturnClosures() to get back that closure, then call it as a function.

    ```swift
    func travelReturnClosures() -> (String) -> Void {
        return {
            print("I'm going to \($0)")
        }
    }

    let result = travelReturnClosures()
    result("London")

    // NOT RECOMMENDED
    let result2 = travelReturnClosures()("London")
    ```

- **Capturing values**

    **If you use any external values inside your closure**, **Swift captures** **them** – stores them alongside the closure.

    Even though that counter variable was created inside travelWithCounter(), it gets captured by the closure so it will still remain alive for that closure.

    ```swift
    func travelWithCounter() -> (String) -> Void {
        var counter = 1
        return {
            print("\(counter). I'm going to \($0)")
            counter += 1
        }
    }

    let resultCounter = travelWithCounter()
    resultCounter("London")
    resultCounter("London")
    resultCounter("London")
    resultCounter("London")
    ```

## Summary

---

- You can assign closures to variables, then call them later on.
- Closures can accept parameters and return values, like regular functions.
- You can pass closures into functions as parameters, and those closures can have parameters of their own and a return value.
- If the last parameter to your function is a closure, you can use trailing closure syntax.
- Swift automatically provides shorthand parameter names like **`$0`** and **`$1`**, but not everyone uses them.
- If you use external values inside your closures, they will be captured so the closure can refer to them later.