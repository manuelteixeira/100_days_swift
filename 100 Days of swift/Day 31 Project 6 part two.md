# Day 31 - Project 6, part two

- **Auto layout metrics and priorities: constraints(withVisualFormat:)**

    ```swift
    view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(==88)]-[label2(==88)]-[label3(==88)]-[label4(==88)]-[label5(==88)]-(>=10)-|", options: [], metrics: nil, views: viewsDictionary))
    ```

    **`(==88)`** for the **labels**, and **`(>=10)`** for the **space to the bottom**. 

    Note that **when specifying the size of a space**, you **need to use** the **`-`** **before and after the size**: a **simple space,** `-`**, becomes `-(>=10)-`.**

    We are specifying **two kinds of size** here: 

    - **`==`**
        - "exactly equal"
        - our labels will be **forced to be an exact size**
    - **`>=`**
        - "greater than or equal to."
        - we ensure that there's **some space at the bottom while also making it flexible** – it **will definitely be at least 10 points**, **but** **could** **be** 100 or **more** depending on the situation.

    **you can give VFL a set of sizes with names**, then **use those sizes in the VFL rather than hard-coding numbers**. 

    ```swift
    let metrics = ["labelHeight": 88]
    ```

    ```swift
    view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight)]-[label2(labelHeight)]-[label3(labelHeight)]-[label4(labelHeight)]-[label5(labelHeight)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))
    ```

    **We're forcing all labels to be a particular height, then adding constraints to the top and bottom.** 

    This still works fine in portrait, but **in landscape you're unlikely to have enough room to satisfy all the constraints.**

    **Constraint priority** is a **value between 1 and 1000**, where **1000 means "this is absolutely required"** and **anything less is optional.** By **default**, **all constraints** you have **are priority 1000**, **so Auto Layout will fail to find a solution in our current layout**.

    But **if we make the height optional** – even as high as priority 999 – it means **Auto Layout can find a solution to our layout: shrink the labels to make them fit.**

    **Constraints are evaluated from highest priority down to lowest, but all are taken into account.**

    Tell Auto Layout that **we want all the labels to have the same height**. This is important, because i**f all of them have optional heights using `labelHeight`, Auto Layout might solve the layout by shrinking one label and making another 88.**

    We're going to **make the first label use `labelHeight` at a priority of 999**, t**hen have the other labels adopt the same height as the first label.**

    ```swift
    "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|"
    ```

    **`@999` that assigns priority to a given constraint**, and using **`(label1)`** **for the sizes** of the other labels is what **tells Auto Layout to make them the same height.**

- **Auto layout anchors**

    **Every** **`UIView` has a set of anchors** **that define its layouts rules.** 

    The **most important** ones **are** **`widthAnchor`**, **`heightAnchor`**, **`topAnchor`**, **`bottomAnchor`**, **`leftAnchor`**, **`rightAnchor`**, **`leadingAnchor`**, **`trailingAnchor`**, **`centerXAnchor`**, and **`centerYAnchor`**.

    - **Difference between `leftAnchor`, `rightAnchor`, `leadingAnchor`, and `trailingAnchor`.**

        For me, **left and leading are the same**, and **right and trailing are the same too**. 

        This is **because my devices are set to use the English language**, which is **written and read left to right.** 

        However, **for right-to-left languages** such as Hebrew and Arabic, leading and trailing flip around so that **leading is equal to right**, and **trailing is equal to left**.

        **In practice, this means** 

        - using **`leadingAnchor`** and **`trailingAnchor`** **if you want your user interface to flip around for right to left languages**,
        - and **`leftAnchor`** and **`rightAnchor`** **for things that should look the same no matter what environment.**

    ```swift
    for label in [label1, label2, label3, label4, label5] {
        label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 88).isActive = true
    }
    ```

    That loops over each of the five labels, **setting them to have the same width as our main view,** **and to have a height of exactly 88 points**.

    What **we want is for the top anchor for each label to be equal to the bottom anchor of the previous label in the loop**. 

    Of course, **the first time the loop goes around there is no previous label, so we can model that using optionals**

    ```swift
    var previous: UILabel?
    ```

    The **first time** the loop goes around that **will be** **`nil`**, but t**hen we’ll set it to the current item in the loop so the next label can refer to it**. I**f previous is not `nil`, we’ll set a `topAnchor` constraint.**

    ```swift
    var previous: UILabel?

    for label in [label1, label2, label3, label4, label5] {
        label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 88).isActive = true

        if let previous = previous {
            // we have a previous label – create a height constraint
            label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
        }

        // set the previous label to be the current one, for the next loop iteration
        previous = label
    }
    ```

    **The “safe area” is the space that’s actually visible inside the insets of the iPhone X and other such devices** – with their rounded corners, notch and similar. 

    **It’s a space that excludes those areas, so labels no longer run underneath the notch or rounded corners.**

    We can push the f**irst label away from the top of the safe area**, so it doesn’t sit under the notch.

    ```swift
    if let previous = previous {
        // we have a previous label – create a height constraint
        label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
    } else {
        // this is the first label
        label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
    }
    ```

- **Challenges**
    1. Try replacing the **`widthAnchor`** of our labels with **`leadingAnchor`** and **`trailingAnchor`** constraints, which more explicitly pin the label to the edges of its parent.

        ```swift
        label.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        ```

        **If you call this method on an `NSLayoutXAxisAnchor` object, this parameter must be another `NSLayoutXAxisAnchor`.**

    2. Once you’ve completed the first challenge, try using the **`safeAreaLayoutGuide`** for those constraints. You can see if this is working by rotating to landscape, because the labels won’t go under the safe area.

        ```swift
        label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        ```

    3. Try making the height of your labels equal to 1/5th of the main view, minus 10 for the spacing. This is a hard one, but I’ve included hints below!

        ```swift
        label.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2, constant: -10).isActive = true
        ```