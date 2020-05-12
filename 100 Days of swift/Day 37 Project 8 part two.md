# Day 37 - Project 8, part two

- **Loading a level and adding button targets**

    ```swift
    HA|UNT|ED: Ghosts in residence
    LE|PRO|SY: A Biblical skin disease
    TW|ITT|ER: Short online chirping
    OLI|VER: Has a Dickensian twist
    ELI|ZAB|ETH: Head of state, British style
    SA|FA|RI: The zoological web
    POR|TL|AND: Hipster heartland
    ```

    Our first task will be to load the level and configure all the buttons to show a letter group. 

    We're going to need two new arrays to handle this: **one to store the buttons** **that are currently being used** to spell an answer, and **one for all the possible solutions**. 

    We also need two integers: **one to hold the player's score**, which will start at 0 but obviously change during play, and **one to hold the current level**.

    ```swift
    var activatedButtons = [UIButton]()
    var solutions = [String]()

    var score = 0
    var level = 1
    ```

    We also need to **create three methods** that will be called from our buttons: **one when submit is tapped**, one **when clear is tapped**, and one **when any of the letter buttons are tapped**. 

    ```swift
    @objc func letterTapped(_ sender: UIButton) {
    }

    @objc func submitTapped(_ sender: UIButton) {
    }

    @objc func clearTapped(_ sender: UIButton) {
    }
    ```

    **Buttons** **have a dedicated `addTarget()`** method that connects the buttons to some code.

    ```swift
    submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
    clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
    letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
    ```

    **`.touchUpInside`** that’s UIKit’s way of saying **that the user pressed down on the button and lifted their touch while it was still inside**. 

    We're going to isolate level loading into a single method, called **`loadLevel()`**. This needs to do two things:

    1. **Load and parse our level text file** in the format I showed you earlier.
    2. **Randomly assign letter groups to buttons.**

    We'll be using the **`enumerated()`** method to loop over an array. It **passes you each object from an array** as part of your loop, **as well as** **that object's position** in the array.

    **`replacingOccurrences()`** This lets you specify two parameters, and **replaces all instances of the first parameter with the second parameter**. We'll be using this to convert "HA|UNT|ED" into HAUNTED so we have a list of all our solutions.

    **`clueString`** will **store all the level's clues**, **`solutionString`** will **store how many letters each answer is** (in the same position as the clues), and **`letterBits`** is an array to **store all letter groups**: HA, UNT, ED, and so on.

    ```swift
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()

        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()

                for (index, line) in lines.enumerated() {
                    let parts = line.components(separatedBy: ": ")
                    let answer = parts[0]
                    let clue = parts[1]

                    clueString += "\(index + 1). \(clue)\n"

                    let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)

                    let bits = answer.components(separatedBy: "|")
                    letterBits += bits
                }
            }
        }

        // Now configure the buttons and labels
    }
    ```

    **`trimmingCharacters(in:)`** **removes any letters you specify from the start and end of a string**. It's most frequently used with the parameter .whitespacesAndNewlines, which trims spaces, tabs and line breaks, and we need exactly that here because our clue string and solutions string will both end up with an extra line break.

    ```swift
    cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
    answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)

    letterBits.shuffle()

    if letterBits.count == letterButtons.count {
        for i in 0 ..< letterButtons.count {
            letterButtons[i].setTitle(letterBits[i], for: .normal)
        }
    }
    ```

    That loop **will count from 0 up to but not including the number of buttons**, which is useful because **we have as many items in our `letterBits` array as our `letterButtons` array**. Looping from 0 to 19 (inclusive) means **we can use the `i` variable to set a button to a letter group.**

- **It's play time: firstIndex(of:) and joined()**

    ```swift
    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    ```

    That does four things:

    1. It **adds a safety check to read the title from the tapped button**, or exit if it didn’t have one for some reason.
    2. **Appends that button title to the player’s current answer**.
    3. **Appends the button to the `activatedButtons` array**
    4. **Hides the button that was tapped.**

    The **`activatedButtons`** array **is being used to hold all buttons that the player has tapped before submitting their answer.**

    ```swift
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""

        for btn in activatedButtons {
            btn.isHidden = false
        }

        activatedButtons.removeAll()
    }
    ```

    This method r**emoves the text from the current answer text field,** **unhides all the activated buttons**, then **removes all the items from the `activatedButtons` array.**

    ```swift
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }

        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()

            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")

            currentAnswer.text = ""
            score += 1

            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done!", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
    }
    ```

    This method will use **`firstIndex(of:)`** to **search through the solutions array for an item** and, **if it finds it, tells us its position.** Remember, **the return** value of firstIndex(of:) **is optional so that in situations where nothing is found you won't get a value back** – we need to unwrap its return value carefully.

    If the **user gets an answer correct, we're going to change the answers label** so that rather than saying "7 LETTERS" it says "HAUNTED", **so they know which ones they have solved already.**

    **`firstIndex(of:)`** will **tell us which solution matched their word**, then **we can use that position to find the matching clue text**. All we need to do is split the answer label text up by **`\n`**, replace the line at the solution position with the solution itself, then re-join the answers label back together.

    **`joined(separator:)`** This **makes an array into a single string**, with each array element separated by the string specified in its parameter.

    **Once that's done, we clear the current answer text field and add one to the score.** 

    **If the score is evenly divisible by 7**, **we know they have found all seven words** so we're going to show a **`UIAlertController`** that will prompt the user to go to the next level.

    We haven’t written a **`levelUp()`** method yet, but it’s not so hard. It needs to:

    1. Add 1 to **`level`**.
    2. Remove all items from the **`solutions`** array.
    3. Call **`loadLevel()`** so that a new level file is loaded and shown.
    4. Make sure all our letter buttons are visible.

    ```swift
    func levelUp(action: UIAlertAction) {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for btn in letterButtons {
            btn.isHidden = false
        }
    }
    ```

- **Property observers: didSet**

    Right now we have a property called score that is set to 0 when the game is created and increments by one whenever an answer is found. But we don't do anything with that score, so our score label is never updated.

    **One solution** to this problem **is to use something like** **`scoreLabel.text = "Score: \(score)"`** **whenever the score value is changed**, and that's perfectly fine to begin with. But what happens if you're changing the score from several places? You need to keep all the code synchronized, which is unpleasant.

    Swift’s solution is **property observers**, which l**et you execute code whenever a property has changed**. To make them work, we use either **`didSet`** to **execute code when a property has just been set**, or **`willSet`** to **execute code before a property has been set**.

    ```swift
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    ```

    Using this method, any time score is changed by anyone, our **`score`** label will be updated.