# Day 29 - Project 5, part three

- **Challenge**
    1. Disallow answers that are shorter than three letters or are just our start word. For the three-letter check, the easiest thing to do is put a check into **`isReal()`** that returns false if the word length is under three letters. For the second part, just compare the start word against their input word and return false if they are the same.

        ```swift
        func isReal(word: String) -> Bool {
                
            if word.count < 3 {
                return false
            }
            
            let checker = UITextChecker()
            let range = NSRange(location: 0, length: word.utf16.count)
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
            
            return misspelledRange.location == NSNotFound
        }
        ```

        ```swift
        func isDifferentAs(word: String) -> Bool {
                
            guard let title = title?.lowercased() else { return false }
            
            return word.lowercased() != title
        }
        ```

    2. Refactor all the **`else`** statements we just added so that they call a new method called **`showErrorMessage()`**. This should accept an error message and a title, and do all the **`UIAlertController`** work from there.

        ```swift
        func submit(_ answer: String) {
                
            let lowerAnswer = answer.lowercased()
                    
            if isDifferentAs(word: lowerAnswer) {
                if isPossible(word: lowerAnswer) {
                    if isOriginal(word: lowerAnswer) {
                        if isReal(word: lowerAnswer) {
                            usedWords.insert(answer.lowercased(), at: 0)
                            
                            let indexPath = IndexPath(row: 0, section: 0)
                            tableView.insertRows(at: [indexPath], with: .automatic)
                            
                            return
                        } else {
                            showErrorMessage(title: "Word not recognised", message: "You can't just make them up, you know!")
                        }
                    } else {
                        showErrorMessage(title: "Word already used", message: "Be more original!")
                    }
                } else {
                    guard let title = title else { return }
                    showErrorMessage(title: "Word not possible", message: "You can't spell that word from \(title.lowercased())")
                }
            } else {
                showErrorMessage(title: "Same word", message: "The word needs to be different from the given word.")
            }
        }
        ```

    3. Add a left bar button item that calls **`startGame()`**, so users can restart with a new word whenever they want to.

        ```swift
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        ```

    4. **Bonus:** To trigger the bug, look for a three-letter word in your starting word, and enter it with an uppercase letter. Once it appears in the table, try entering it again all lowercase – you’ll see it gets entered. Can you figure out what causes this and how to fix it?

        ```swift
        usedWords.insert(answer.lowercased(), at: 0)
        ```

        ```swift
        func isOriginal(word: String) -> Bool {
                
            return !usedWords.contains(word.lowercased())
        }
        ```