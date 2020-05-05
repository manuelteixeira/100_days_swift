# Day 21 - Project 2, part three

- **Challenge**
    1. Try showing the player’s score in the navigation bar, alongside the flag to guess.

        ```swift
        // askQuestion method
        title = "\(countries[correctAnswer].uppercased()) - score: \(score)"
        ```

    2. Keep track of how many questions have been asked, and show one final alert controller after they have answered 10. This should show their final score.

        Add a property for view controller to keep the questions answered.

        ```swift
        var questionsCount = 0
        ```

        Update the buttonTapped method to show the final score alert if the questions answered reach the maximum.

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
            
            var message = "Your score is \(score)"
            
            questionsCount += 1
            
            if questionsCount == 10 {
                title = "You have answered \(questionsCount) questions"
                message = "Your final score is \(score)"
                
                resetGame()
            }
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            
            present(alertController, animated: true)
        }
        ```

        Method to reset the game score and questions answered.

        ```swift
        func resetGame() {
            questionsCount = 0
            score = 0
        }
        ```

    3. When someone chooses the wrong flag, tell them their mistake in your alert message – something like “Wrong! That’s the flag of France,” for example.

        ```swift
        // buttonTapped method
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That’s the flag of \(countries[sender.tag].capitalized)"
            score -= 1
        }
        ```