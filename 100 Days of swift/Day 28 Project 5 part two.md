# Day 28 - Project 5, part two

- **Prepare for submission: lowercased() and IndexPath**

    ```swift
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)

                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    ```

    Once we know the word is good, we do **three things**: 

    - **Insert the new word into our usedWords array at index 0.** This means "add it to the start of the array," and means that the **newest words will appear at the top of the table view.**
    - **We insert a new row into the table view.** We could just call the **`reloadData()`** method and have the table do a full reload of all rows, but it **means a lot of extra work for one small change, and also causes a jump – the word wasn't there, and now it is.**

        **Using `insertRows()` lets us tell the table view that a new row has been placed at a specific place in the array so that it can animate the new cell appearing. Adding one cell is also significantly easier than having to reload everything.**

    - **`IndexPath`** We aren't using sections here, but the row number should equal the position we added the item in the array – position 0, in this case.
    - The **`with`** parameter lets you **specify how the row should be animated in.** Whenever you're adding and removing things from a table, the **`.automatic`** value means **"do whatever is the standard system animation for this change."** In this case, it means "slide the new row in from the top."

- **Checking for valid answers**

    ```swift
    func isOriginal(word: String) -> Bool {
    	  return !usedWords.contains(word)
    }
    ```

    Will check whether our usedWords array already contains the word that was provided.

    ```swift
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }

        for letter in word {
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }

        return true
    }
    ```

    **Loop through every letter in the player's answer**, **seeing whether it exists in the start word we are playing with.** 

    **If it does exist**, we **remove the letter from the start word**, then continue the loop. So, if we try to use a letter twice, it will exist the first time, but then get removed so it doesn't exist the next time, and the check will fail.

    **`firstIndex(of:)`**, will **return the first position of the substring if it exists or `nil` otherwise.**

    We use **`remove(at:)`** **to remove the used letter from the `tempWord` variable**.

    ```swift
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        return misspelledRange.location == NSNotFound
    }
    ```

    **`UITextChecker`** This is an iOS class that is designed to **spot spelling errors.**

    **`NSRange`** This is **used to store a string range**, which is **a value that holds a start position and a length.** We want to examine the whole string, so we use 0 for the start position and the string's length for the length.

    **`rangeOfMisspelledWord(in:)`** The first parameter is our string, **`word`**, the second is our range to scan (the whole string), and the last is the language we should be checking with, where **`en`** selects English.

    **Parameter three** **selects a point in the range where the text checker should start scanning**, and **parameter four** lets us **set whether the `UITextChecker` should start at the beginning of the range** **if no misspelled words were found** **starting from parameter three.**

    **`rangeOfMisspelledWord(in:)`** **returns `NSRange`** structure, which **tells us where the misspelling was found**. But what we care about was whether any misspelling was found, and **if nothing was found our `NSRange` will have the special location `NSNotFound`**. Usually location would tell you where the misspelling started, but **`NSNotFound`** is telling us the word is spelled correctly – i.e., it's a valid word.

- **Or else what?**

    ```swift
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()

        let errorTitle: String
        let errorMessage: String

        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)

                    let indexPath = IndexPath(row: 0, section: 0)
                    tableView.insertRows(at: [indexPath], with: .automatic)

                    return
                } else {
                    errorTitle = "Word not recognised"
                    errorMessage = "You can't just make them up, you know!"
                }
            } else {
                errorTitle = "Word used already"
                errorMessage = "Be more original!"
            }
        } else {
            guard let title = title?.lowercased() else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title)"
        }

        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    ```

    As you can see, every if statement now has a matching else statement so that the user gets appropriate feedback.

    set the values for **`errorTitle`** and **`errorMessage`** to something useful for the user.

    **`UIAlertController`** **with the error title and message that was set, add an OK button without a handler** (i.e., just dismiss the alert), then show the alert. So, this error will only be shown if something went wrong.

    **`errorTitle`** and **`errorMessage`** **were declared as constants**, which means their value cannot be changed once set. I didn't give either of them an initial value, and that's OK – Swift lets you do this as long as you do provide a value before the constants are read, and also as long as you don't try to change the value again later on.