# Day 1 - variables, simple data types, and string interpolation

- **Variables**

    ```swift
    var str = "Hello, playground"
    str = "Goodbye"
    ```

- **Integers**

    ```swift
    var age = 38
    var population = 8_000_000
    ```

- **Multiline strings**

    The quotes **must be on a line by themselves**

    ```swift
    var multiLineStr = """
    This line
    goes to
    multiple lines
    """

    var multiLineStrWithoutLineBreaks = """
    This line \
    goes to \
    multiple lines
    """
    ```

- **Doubles and booleans**

    ```swift
    var pi = 3.14
    var awesome = true
    ```

- **String interpolation**

    ```swift
    var score = 85
    var strWithScore = "The score is \(score)"
    var strWithStr = "The results are: \(strWithScore)"
    ```

- **Constants**

    ```swift
    let taylor = "swift"
    //taylor = "cant change this constant"
    ```

- **Type annotation**

    ```swift
    let withTypeInfered = "This is a string"
    let withExplicitType: String = "Reputation"
    let year: Int = 1989
    let height: Double = 1.78
    let taylorRocks: Bool = true
    ```

## Summary

---

- You make variables using **var** and constants using **let**. It’s preferable to **use constants as often as possible**.
- **Strings start and end with double quotes**, but if you want them to run across **multiple lines** you should **use three sets of double quotes**.
- **Integers** hold **whole numbers**, **doubles hold fractional** numbers, and **booleans hold true or false**.
- **String interpolation allows you to create strings from other variables** and constants, placing their values inside your string.
- **Swift uses type inference** to assign each variable or constant a type, but **you can provide explicit types** if you want.