# Day 38 - Project 8, part three

- **Challenge**

    1. Use the techniques you learned in project 2 to draw a thin gray line around the buttons view, to make it stand out from the rest of the UI.

        ```swift
        buttonsView.layer.borderColor = UIColor.darkGray.cgColor
        buttonsView.layer.borderWidth = 2
        ```

    2. If the user enters an incorrect guess, show an alert telling them they are wrong. You’ll need to extend the **`submitTapped()`** method so that if **`firstIndex(of:)`** failed to find the guess you show the alert.

        ```swift
        @objc func submitTapped(_ sender: UIButton) {
            guard let answerText = currentAnswer.text else { return }
            
            if let solutionPosition = solutions.firstIndex(of: answerText) {
                // ...
            } else {
                showIncorrectGuessAlert()
            }
        }
        ```

        ```swift
        func showIncorrectGuessAlert() {
            let alertController = UIAlertController(title: "Incorrect guess!", message: "Try again", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(action)
            
            present(alertController, animated: true)
        }
        ```

    3. Try making the game also deduct points if the player makes an incorrect guess. Think about how you can move to the next level – we can’t use a simple division remainder on the player’s **`score`** any more, because they might have lost some points.

        ```swift
        var questionsAnsweredCorrectly = 0
        let maxQuestions = 7
        ```

        ```swift
        @objc func submitTapped(_ sender: UIButton) {
            guard let answerText = currentAnswer.text else { return }
            
            if let solutionPosition = solutions.firstIndex(of: answerText) {
                // ...
                score += 1
                questionsAnsweredCorrectly += 1
                
                if questionsAnsweredCorrectly == maxQuestions {
                    let alertController = UIAlertController(title: "Well done", message: "Are you ready for next level?", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Let's go", style: .default, handler: levelUp))
                    present(alertController, animated: true)
                }
            } else {
                score -= 1
                showIncorrectGuessAlert()
            }
        }
        ```

        Or without the **`questionsAnsweredCorrectly`** variable

        ```swift
        @objc func submitTapped(_ sender: UIButton) {
            guard let answerText = currentAnswer.text else { return }
            
            if let solutionPosition = solutions.firstIndex(of: answerText) {
                // ...
                score += 1
                
                for button in letterButtons {
                    if !button.isHidden {
                        return
                    }
                }
                
                let alertController = UIAlertController(title: "Well done", message: "Are you ready for next level?", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Let's go", style: .default, handler: levelUp))
                present(alertController, animated: true)
                
            } else {
                score -= 1
                showIncorrectGuessAlert()
            }
        }
        ```