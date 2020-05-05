# Day 4 - loops, loops, and more loops

- **For loops**

    Loop over **arrays** **and ranges**, and **each time the loop goes around** it will **pull out one item** and **assign** to a **constant**.

    ```swift
    let count = 1...10

    for number in count {
        print("Number is \(number)")
    }

    let albums = ["Red", "1989", "Reputation"]

    for album in albums {
        print("\(album) is on Apple music")
    }

    print("Players gonna ")

    for _ in 1...5 {
        print("Play")
    }
    ```

- **While loops**

    ```swift
    var number = 1

    while number <= 20 {
        print(number)
        number += 1
    }
    ```

- **Repeat loops**

    **It will run at least one time.**

    Since the condition is checked at the end of the repeat loop.

    ```swift
    var number = 1

    repeat {
        print(number)
        number += 1
    } while number <= 20
    ```

- **Exiting loops**

    You can exit a loop at any time using the **break** keyword.

    ```swift
    var countDown = 10

    while countDown >= 0 {
        print(countDown)
        
        if countDown == 4 {
            print("I'm bored")
            break
        }
        
        countDown -= 1
    }
    ```

- **Exiting multiple loops**

    If you want to break both loops we need to:

    - Give a outside loop a **label** (**outerLoop**)
    - Use **break outerLoop** inside inner loop

    ```swift
    outerLoop: for i in 1...10 {
        for j in 1...10 {
            let product = i * j
            print("\(i) * \(j) is \(product)")
            
            if product == 50 {
                print("It's a bullseye!")
                break outerLoop
            }
        }
    }
    ```

- **Skipping items**

    If you want to skip the current item and continue on to the next one you use **continue.**

    In this case it will only print the even numbers.

    ```swift
    for i in 1...10 {
        if i % 2 == 1 {
            continue
        }
        
        print(i)
    }
    ```

- **Infinite loops**

    Loops that either have **no end** **or** only **end when you’re ready**.

    **Warning**: Please make sure you have a check that exits your loop, otherwise it will never end.

    ```swift
    var counter = 0

    while true {
        print(" ")
        counter += 1
        
        if counter == 273 {
            break
        }
    }
    ```

## Summary

---

- Loops let us repeat code until a condition is false.
- The most common loop is **`for`**, which assigns each item inside the loop to a **temporary constant**.
- If you **don’t need the temporary constant** that **`for`** loops give you, **use** an **underscore** instead so Swift can skip that work.
- There are **`while`** loops, which you provide with an explicit condition to check.
- Although they are similar to **`while`** loops, **`repeat`** loops **always run the body of their loop at least once.**
- You can exit a **single loop** using **`break`**, but if you have **nested loops** you need to use **`break`** **followed by whatever label** you placed before your outer loop.
- You can **skip items** in a loop using **`continue`**.
- Infinite loops don’t end until you ask them to, and are made using **`while true`**. **Make sure you have a condition somewhere to end your infinite loops!**