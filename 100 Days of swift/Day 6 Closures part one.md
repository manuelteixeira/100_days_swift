# Day 6 - Closures part one

- **Creating basic closures**

    You can **create a function and assign it to a variable**, **call that function using that variable**, and even **pass that function** into other functions as parameters.

    ```swift
    let driving = {
        print("I'm driving my car")
    }

    driving()
    ```

- **Accepting parameters in a closure**

    **List them inside parentheses just after the opening brace**, **then** write **in** so that Swift knows the main body of the closure is starting.

    One of the differences between functions and closures is that **you don’t use parameter labels** when running closures.

    ```swift
    let drivingParameters = { (place: String) in
        print("I'm going to \(place) in my car")
    }

    drivingParameters("London")
    ```

- **Returning values from a closure**

    Write them inside your closure, directly **before the in keyword**.

    ```swift
    let drivingWithReturn = { (place: String) -> String in
        return "I'm going to \(place) in my car"
    }

    let message = drivingWithReturn("London")
    print(message)
    ```

- **Closures as parameters**

    You can pass closures into functions.

    If we wanted to pass **that** **closure into a function** so it can be run inside that function, we would specify the **parameter type as () -> Void**. 

    That means "**accepts no parameters, and returns Void**"

    ```swift
    let cycling = {
        print("I'm cycling in my bike")
    }

    func travel(action: () -> Void) {
        print("I'm getting ready to go")
        action()
        print("I arrived")
    }

    travel(action: cycling)
    ```

- **Trailing closure syntax**

    **If the last parameter to a function is a closure**, Swift lets you use special syntax called trailing closure syntax.

    Rather than pass in your closure as a parameter, **you pass it directly after the function inside braces**.

    ```swift
    func travel(action: () -> Void) {
        print("I'm getting ready to go")
        action()
        print("I arrived")
    }

    travel() {
        print("I'm driving in my car")
    }
    ```

    In fact, because there **aren’t any other parameters**, we can eliminate the parentheses entirely:

    ```swift
    travel {
        print("I'm driving in my car")
    }
    ```