# Day 36 - Project 8, part one

- **Building a UIKit user interface programmatically**

    ![Day%2036%20Project%208%20part%20one%206cc978873e0c4833afb01a3fdfece8ae/Untitled.png](Day%2036%20Project%208%20part%20one%206cc978873e0c4833afb01a3fdfece8ae/Untitled.png)

    ```swift
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    ```

    ```swift
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white

        // more code to come!
    }
    ```

    **Create the main view itself as a big and white empty space**. This is just a matter of creating a **new** **instance of `UIView`, giving it a white background color, and assigning that to our view controller’s `view` property.**

    **`UIView`** is the **parent class of all of UIKit’s view types**: labels, buttons, progress views, and more.

    ## **Placing three labels at the top**

    ```swift
    scoreLabel = UILabel()
    scoreLabel.translatesAutoresizingMaskIntoConstraints = false
    scoreLabel.textAlignment = .right
    scoreLabel.text = "Score: 0"
    view.addSubview(scoreLabel)
    ```

    We’ll be creating lots of constraints at the same time, we’ll be activating them all at once rather than setting **`isActive = true`** multiple times.

    This is done using the **`NSLayoutConstraint.activate()`** method, **which accepts an array of constraints.** It will put them all together at once, so we’ll be adding more constraints to this call over time.

    **UIKit gives us several guides that we can anchor our views to.** One of the **most common is** the **`safeAreaLayoutGuide`** of our main view, **which is the space available once you subtract any rounded corners or notches**. **Inside that is** the **`layoutMarginsGuide`**, **which adds some extra margin so that views don’t run to the left and right edges of the screen**.

    ```swift
    NSLayoutConstraint.activate([
        scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
        scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])
    ```

    That will make the **score label have a little distance from the right edge of the screen.**

    Next we’re going to **add the clues and answers labels**. The **`font`** property **describes what kind of text font is used** to render the label, and is provided as a dedicated type that describes a font face and size: UIFont. **`numberOfLines`** is an integer that **sets how many lines the text can wrap over**, but we’re going to set it to **`0`** – a magic value that **means “as many lines as it takes.”**

    ```swift
    cluesLabel = UILabel()
    cluesLabel.translatesAutoresizingMaskIntoConstraints = false
    cluesLabel.font = UIFont.systemFont(ofSize: 24)
    cluesLabel.text = "CLUES"
    cluesLabel.numberOfLines = 0
    view.addSubview(cluesLabel)

    answersLabel = UILabel()
    answersLabel.translatesAutoresizingMaskIntoConstraints = false
    answersLabel.font = UIFont.systemFont(ofSize: 24)
    answersLabel.text = "ANSWERS"
    answersLabel.numberOfLines = 0
    answersLabel.textAlignment = .right
    view.addSubview(answersLabel)
    ```

    Using **`UIFont.systemFont(ofSize: 24)`** will **give us a 24-point font in whatever font is currently being used by iOS.**

    ```swift
    // pin the top of the clues label to the bottom of the score label
    cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

    // pin the leading edge of the clues label to the leading edge of our layout margins, adding 100 for some space
    cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),

    // make the clues label 60% of the width of our layout margins, minus 100
    cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),

    // also pin the top of the answers label to the bottom of the score label
    answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),

    // make the answers label stick to the trailing edge of our layout margins, minus 100
    answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),

    // make the answers label take up 40% of the available space, minus 100
    answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),

    // make the answers label match the height of the clues label
    answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
    ```

    ## **Entering answers**

    Next we’re going to add a **`UITextField`** that will show the user’s answer as they are building it. However, this lets me introduce you to the **`placeholder`** property of text fields, which draws gray prompt text that the user can type over – it looks really nice, and gives us space to provide some instructions to users.

    As with our labels we’re also going to adjust the font and alignment of the text field, but we’re also going to disable user interaction so the user can’t tap on it – we don’t want the iOS keyboard to appear.

    ```swift
    currentAnswer = UITextField()
    currentAnswer.translatesAutoresizingMaskIntoConstraints = false
    currentAnswer.placeholder = "Tap letters to guess"
    currentAnswer.textAlignment = .center
    currentAnswer.font = UIFont.systemFont(ofSize: 44)
    currentAnswer.isUserInteractionEnabled = false
    view.addSubview(currentAnswer)
    ```

    **`isUserInteractionEnabled`** to `**false`, which is what stops the user from activating the text field and typing into it.**

    As for constraints, we’re going to **make this text field centered in our view**, but **only 50% its width**. We’re also going to **place it below the clues label, with 20 points of spacing** so the two don’t touch.

    ```swift
    currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
    currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
    ```

    **Below the text field we’re going to add two buttons**.

    To create a **`UIButton`** in code you need to know two things:

    1. Buttons have various built-in styles, but the ones you’ll most commonly use are **`.custom`** and **`.system`**.
    2. We need to use **`setTitle()`** to adjust the title on the button.

    ```swift
    let submit = UIButton(type: .system)
    submit.translatesAutoresizingMaskIntoConstraints = false
    submit.setTitle("SUBMIT", for: .normal)
    view.addSubview(submit)

    let clear = UIButton(type: .system)
    clear.translatesAutoresizingMaskIntoConstraints = false
    clear.setTitle("CLEAR", for: .normal)
    view.addSubview(clear)
    ```

    **Note**: We don’t need to store those as properties on the view controller, because we don’t need to adjust them later.

    In terms of the constraints to add for those buttons, they need three each:

    1. **One to set their vertical position**. For the submit button we’ll be using the bottom of the current answer text field, but for the clear button we’ll be setting its Y anchor so that its stays aligned with the Y position of the submit button. This means both buttons will remain aligned even if we move one.
    2. We’re going to **center them both horizontally in our main view**. To stop them overlapping, we’ll subtract 100 from the submit button’s X position, and add 100 to the clear button’s X position. “100” isn’t any sort of special number – you can experiment with different values and see what looks good to you.
    3. We’re going to **force both buttons to have a height of 44 points**. Apple’s human interface guidelines recommends buttons be at least 44x44 so they can be tapped easily.

    ```swift
    submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
    submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
    submit.heightAnchor.constraint(equalToConstant: 44),

    clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
    clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
    clear.heightAnchor.constraint(equalToConstant: 44),
    ```

    ## **Buttons… buttons everywhere!**

    With complicated layouts like this one the smart thing to do is wrap things in a container view. In our case this means **we’re going to create one container view that will house all the buttons, then give *that* view constraints so that it’s positioned correctly on the screen.**

    This is just going to be a **plain** **`UIView`** – it does nothing special other than host our buttons.

    ```swift
    let buttonsView = UIView()
    buttonsView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(buttonsView)
    ```

    we need to give it more constraints so that Auto Layout knows our hierarchy is complete:

    1. We’re going to **give it a width and height of 750x320**.
    2. It will be **centered horizontally**.
    3. We’ll set its **top anchor to be the bottom of the submit button, plus 20 points to add a little spacing.**
    4. We’ll **pin it to the bottom of our layout margins**, **-20 so that it doesn’t run quite to the edge.**

    ```swift
    buttonsView.widthAnchor.constraint(equalToConstant: 750),
    buttonsView.heightAnchor.constraint(equalToConstant: 320),
    buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
    buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
    ```

    Everything that used to be pinned to the top has now been pulled downwards. This isn’t a mistake, or an Auto Layout bug, but is the natural result of all the rules we’ve laid down:

    - Our buttons view should be pinned to the bottom and be exactly 320 points high.
    - The submit button should be above the buttons view.
    - The current answer text field should be above the submit button.
    - The answers label should be above the current answer text field.
    - The score label should be above the answers label.
    - The score label should be pinned to the top of our view.

    In short, we have the buttons view pinned to the bottom and the score label pinned to the top, with all our other views in between.

    **Before we added the final buttons view, Auto Layout had no special idea of how big any of the views should be, so it used something called the** 

    ***intrinsic content size*** – **how big each view needs to be to show its content**. 

    This resulted in our views being neatly arranged at the top. But now we have a complete vertical stack, pinned at the top and bottom, so UIKit needs to fill the space in between by stretching one or more of the views.

    Every view in all our UIKit layouts has two important properties that tell UIKit how it can squash or stretch them in order to satisfy constraints:

    - **Content hugging priority** determines **how likely this view is to be made larger than its intrinsic content size**. If this **priority is high** it means **Auto Layout prefers not to stretch it**; if it’s **low, it will be more likely to be stretched.**
    - **Content compression resistance priority** determines **how happy we are for this view to be made smaller than its intrinsic content size**.

    Both of those values have a **default: 250 for content hugging, and 750 for content compression resistance.** 

    Remember, higher priorities mean Auto Layout works harder to satisfy them, so you can see that views are usually fairly happy to be stretched, but prefer not to be squashed. 

    Because all views have the same priorities for these two values, Auto Layout is forced to pick one to stretch – the score at the top.

    Now, all this matters because we’re going to adjust the content hugging priority for our clues and answers labels. More specifically, we’re going to give them a priority of 1, so that when Auto Layout has to decide which view to stretch they are first in line.

    ```swift
    cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
    ```

    the two labels now take up much more space, and the rest of our user interface looks more normal.

    **We have 20 buttons to create** across **four rows** and **five columns**.

    We’re going to rely on a lovely feature of Auto Layout to make this whole process much easier: **we’re not going to set `translatesAutoresizingMaskIntoConstraints` to `false`** for these buttons, which **means we can give them a specific position and size and have UIKit figure out the constraints for us.**

    this actual button creation isn’t as hard as you might think:

    1. **Set constants to represent the width and height** of our buttons for easier reference.
    2. Loop through rows 0, 1, 2, and 3.
    3. Loop through columns 0, 1, 2, 3, and 4.
    4. Create a new button with a nice and large font – we can adjust the font of a button’s label using its **`titleLabel`** property.
    5. **Calculate the X position of the button as being our column number multiplied by the button width.**
    6. **Calculate the Y position of the button as being our row number multiplied by the button height.**
    7. Add the button to our **`buttonsView`** rather than the main view.

    As a bonus, we’re going to add each button to our **`letterButtons`** array as we create them, so that we can control them later in the game.

    Calculating positions of views by hand isn’t something we’ve done before, because we’ve been relying on Auto Layout for everything. However, it’s no harder than sketching something out on graph paper: **we create a rectangular frame that has X and Y coordinates plus width and height**, then **assign that to the `frame` property of our view**. **These rectangles have a special type called `CGRect`, because they come from Core Graphics.**

    As an **example**, we’ll be calculating the X position for a button by multiplying our fixed button width (150) by its column position. So, for **column 0 that will give an X coordinate of 150x0, which is 0,** and for **column 1 that will give an X coordinate of 150x1, which is 150** – they will line up neatly.

    ```swift
    // set some values for the width and height of each button
    let width = 150
    let height = 80

    // create 20 buttons as a 4x5 grid
    for row in 0..<4 {
        for col in 0..<5 {
            // create a new button and give it a big font size
            let letterButton = UIButton(type: .system)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)

            // give the button some temporary text so we can see it on-screen
            letterButton.setTitle("WWW", for: .normal)

            // calculate the frame of this button using its column and row
            let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
            letterButton.frame = frame

            // add it to the buttons view
            buttonsView.addSubview(letterButton)

            // and also to our letterButtons array
            letterButtons.append(letterButton)
        }
    }
    ```