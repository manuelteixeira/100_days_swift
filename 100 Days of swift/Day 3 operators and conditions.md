# Day 3 - operators and conditions

- **Arithmetic Operators**

    ```swift
    let firstScore = 12
    let secondScore = 4

    let total = firstScore + secondScore
    let difference = firstScore - secondScore

    let product = firstScore * secondScore
    let divided = firstScore / secondScore
    let remainder = 13 % secondScore
    ```

- **Operator overloading**

    An operator depends on the values you use it with.

    Swift won't let you mix types.

    ```swift
    let meaningOfLife = 42
    let doubleMeaning = 42 + 42

    let fakers = "Fakers gonna "
    let action = fakers + "fake"

    let firstHalf = ["John", "Paul"]
    let secondHalf = ["George", "Ringo"]
    let beatles = firstHalf + secondHalf
    ```

- **Compound assignment operators**

    We can change a variable in place.

    They assign the result back to whatever variable you were using.

    ```swift
    var score = 95
    score -= 5

    var quote = "The rain in Spain falls mainly on the "
    quote += "Spaniards"
    ```

- **Comparison operators**

    This also works with strings, because strings have a natural alphabetical order.

    ```swift
    let firstComparisonScore = 6
    let secondComparisonScore = 4

    firstComparisonScore == secondComparisonScore
    firstComparisonScore != secondComparisonScore

    firstComparisonScore < secondComparisonScore
    firstComparisonScore >= secondComparisonScore

    "Taylor" <= "Swift"
    ```

- **Conditions**

    ```swift
    let firstCard = 11
    let secondCard = 10

    if firstCard + secondCard == 2 {
        print("Aces A lucky!")
    } else if firstCard + secondCard == 21 {
        print("Blackjack!")
    } else {
        print("Regular cards")
    }
    ```

- **Combining conditions**

    **&&:** if both conditions are true

    **||:** one of them is true

    ```swift
    let age1 = 12
    let age2 = 21

    if age1 > 18 && age2 > 18 {
        print("Both are over 18")
    }

    if age1 > 18 || age2 > 18 {
        print("One of them is over 18")
    }
    ```

- **The ternary operator**

    **Checks** the **first value** condition if is **true** **returns the second value**, **else** it **returns the third value**

    ```swift
    let firstExample = 11
    let secondExample = 10

    print(firstExample == secondExample ? "Values are the same" : "Values are different")

    // Regular condition
    if firstExample == secondExample {
        print("Values are the same")
    } else {
        print("Values are different")
    }
    ```

- **Switch statements**

    **default** is required because Swift makes sure you cover all possible cases.

    The default may not be need if we cover all other cases such with an enum

    Swift will only **run the code inside each case**.

    If you want execution to continue on to the next case use **fallthrough**

    ```swift
    let weather = "sunny"

    switch weather {
    case "rain":
        print("Bring an umbrella") 
    case "snow":
        print("Wrap up warm")
    case "sunny":
        print("Wear sunscreen")
        fallthrough
    default:
        print("Enjoy your day!") 
    }
    ```

- **Range operators**

    **..<** ranges up to but **excluding** **the final value**

    1..<5 contains the numbers 1, 2, 3, 4

    **...** ranges up to but **including the final value**

    1...5 contains the number 1, 2, 3, 4, 5

    ```swift
    let score = 85

    switch score {
    case 0..<50:
        print("You failed")
    case 50..<85:
        print("You did OK")
    default:
        print("You did great!") 
    }
    ```

## Summary

---

- Swift has operators for doing arithmetic and for comparison; they mostly work like you already know.
- There are compound variants of arithmetic operators that modify their variables in place: **`+=`**, **`-=`**, and so on.
- You can use **`if`**, **`else`**, and **`else if`** to run code based on the result of a condition.
- Swift has a ternary operator that combines a check with true and false code blocks.
- If you have multiple conditions using the same value, it’s often clearer to use **`switch`** instead.
- You can make ranges using **`..<`** and **`...`** depending on whether the last number should be excluded or included.