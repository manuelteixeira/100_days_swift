# Day 20 - Project 2, part two

- **Guess which flag: random numbers**

    **`shuffle()`** for **in-place shuffling**, and **`shuffled()`** to **return a new, shuffled array.**

    That will automatically **randomize** the order of the countries in the array

    ```swift
    countries.shuffle()
    ```

    Track which answer should be the correct one, and to do that we're going to create a new property for our view controller called **`correctAnswer`**. Put this near the top, just above **`var score = 0`**

    ```swift
    var correctAnswer = 0
    ```

    **All Swift’s numeric types**, such as **`Int`**, **`Double`**, and **`CGFloat`**, **have a `random(in:)` method** that **generates a random number in a range**.

    ```swift
    correctAnswer = Int.random(in: 0...2)
    ```

    Now that we have the correct answer, we just need to put its text into the **navigation bar**. This can be done by using the **`title`** property of our view controller.

    ```swift
    title = countries[correctAnswer].uppercased()
    ```

- **From outlets to actions: creating an IBAction**

    We're going to connect the "tap" action of our **`UIButtons`** to some code.

    Next we add a tag to each button so we know which button was tapped.

    we're going to use a new data type called **`UIAlertController()`**. This is used to **show an alert with options to the user.**

    **`UIAlertController()`** gives us **two kinds of style**: **`.alert`**, which **pops up a message box over the center of the screen**, and **`.actionSheet`**, which **slides options up from the bottom**.

    The **handler** **parameter** is **looking for a closure**, which is some code that it can execute when the button is tapped. You can write custom code in there if you want, but in our case we want the game to continue when the button is tapped, so we pass in askQuestion so that iOS will call our askQuestion() method.

    **Warning**: We must use **`askQuestion`** and not **`askQuestion()`**. If you use the former, it means "here's the name of the method to run," but if you use the latter it means "run the askQuestion() method now, and it will tell you the name of the method to run."

    ```swift
    @IBAction func buttonTapped(_ sender: UIButton) {
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        let alertController = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Coontinue", style: .default, handler: askQuestion))
        
        present(alertController, animated: true)
    }
    ```

    Before the code completes, there's a problem, and Xcode is probably telling you what it is: “Cannot convert value of type ‘() -> ()’ to expected argument type ‘((UIAlertAction) -> Void)?’.”

    What it *means* to say is that **using a method for this closure is fine**, **but** **Swift wants the method to accept a** **`UIAlertAction`** **parameter** **saying** **which** **`UIAlertAction`** **was** **tapped**.

    To make this problem go away, we need to change the way the **`askQuestion()`** method is defined.

    ```swift
    func askQuestion(action: UIAlertAction! = nil) { ... }
    ```