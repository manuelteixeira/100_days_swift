# Day 12 - Optionals

- **Handling missing data**

    You can make **optionals out of any type**.

    An **optional** integer might have a number like 0 or 40, but it might have no value at all – it might literally be missing, which is **nil** in Swift.

    ```swift
    var age: Int? = nil
    age = 29
    ```

- **Unwrapping optionals**

    We must look inside the optional and see what’s there – a process known as **unwrapping**.

    A common way of unwrapping optionals is with **if let syntax**, which unwraps with a condition. **If there was a value inside the optional then you can use it**, **but if there wasn’t the condition fails.**

    ```swift
    var name: String? = nil

    if let unwrapped = name {
        print("\(unwrapped.count) letter")
    } else {
        print("Missing name.")
    }
    ```

- **Unwrapping with guard**

    **Difference** between **if let and guard let** is that **your unwrapped** **optional** **remains** **usable** **after** **the** **guard** code.

    Using guard let **lets you deal with problems at the start** of your functions, then exit immediately.

    ```swift
    func greet(_ name: String?) {
        guard let unwrapped = name else {
            print("You didn't provide a name!")
            return
        }
        
        print("Hello, \(unwrapped)!")
    }
    ```

- **Force unwrapping**

    **You should force unwrap only when you’re sure it’s safe.**

    ```swift
    let str = "5"
    let num = Int(str)!
    ```

- **Implicity unwrapped optionals**

    Implicitly unwrapped optionals **might contain a value or they might be nil.**

    You **don’t need to unwrap** them in order to use them.

    If you **try to use** them **and they are nil** – your **code crashes.**

    Implicitly unwrapped optionals exist because sometimes a variable will start life as nil, but will always have a value before you need to use it.

    ```swift
    let years: Int! = nil
    ```

- **Nil coalescing**

    **Unwraps an optional and returns the value inside if there is one**. **If** there isn’t a value – if the optional was **nil** – **then a default value is used** instead.

    ```swift
    func username(for id: Int) -> String? {
        if id == 1 {
            return "Taylor Swift"
        } else {
            return nil
        }
    }

    let user = username(for: 15) ?? "Anonymous"
    ```

- **Optional chaining**

    If you want to access something like **a.b.c** and **b** **is optional**, you can write a question mark after it to enable optional chaining: **a.b?.c.**

    Swift will **check** **whether b has a value**, and:

    **If it’s nil** **the rest of the line will be ignored. Swift will return nil.**

    But if it has a value, it **will be unwrapped and execution will continue.**

    ```swift
    let names = ["John", "Paul", "George", "Ringo"]
    let beatle = names.first?.uppercased()
    ```

- **Optional try**

    **try?** 

    **Changes** **throwing** **functions** **into functions that return an optiona**l.

    **If the function throws an error you’ll be sent nil as the result**, **otherwise you’ll get the return value wrapped as an optional.**

    **try!**

    Which you can use **when you know for sure that the function will not fail.** 

    **If the function does throw an error, your code will crash.**

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

    if let result = try? checkPassword("password") {
        print("Result was \(result)")
    } else {
        print("D'oh")
    }

    try! checkPassword("sekrit")
    print("Ok!")
    ```

- **Failable initializers**

    An initializer that **might work or might not.**

    Return **nil** **if something goes wrong**. 

    The **return value will** then **be an optional** of your type, for you to unwrap however you want.

    ```swift
    struct Person {
        var id: String
        
        init?(id: String) {
            if id.count == 9 {
                self.id = id
            } else {
                return nil
            }
        }
    }

    let person = Person(id: "12")
    person?.id
    ```

- **Typecasting**

    Uses keyword **as?**, **which returns an optional.**

    It will be nil if the typecast failed, or a converted type otherwise.

    ```swift
    class Animal {}
    class Fish: Animal {}
    class Dog: Animal {
        func makeNoise() {
            print("Woof")
        }
    }

    let pets = [Fish(), Dog(), Fish(), Dog()]

    for pet in pets {
        if let dog = pet as? Dog {
            dog.makeNoise()
        } 
    }
    ```

## Summary

---

- **Optionals** let us **represent the absence of a value** in a clear and unambiguous way.
- Swift **won’t let us use optionals without unwrapping them**, either using **`if let`** or using **`guard let`**.
- **You can force unwrap optionals** with an exclamation mark, but if you try to force unwrap **`nil`** your code will crash.
- **Implicitly unwrapped optionals don’t have the safety checks of regular optionals.**
- You can use **nil coalescing to unwrap an optional and provide a default** value if there was nothing inside.
- **Optional chaining lets us write code to manipulate an optional**, but if the optional turns out to be empty the code is ignored.
- You can use **`try?`** to **convert a throwing function into an optional return** value, or **`try!`** to crash if an error is thrown.
- If you need your initializer to fail when it’s given bad input, use **`init?()`** to make a failable initializer.
- You can use **typecasting to convert one type of object to another.**