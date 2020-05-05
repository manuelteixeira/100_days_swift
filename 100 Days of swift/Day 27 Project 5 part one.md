# Day 27 - Project 5, part one

- **Capture lists in Swift: what’s the difference between weak, strong, and unowned references?**

    **Capture lists come before a closure’s parameter list** in your code, and **capture values from the environment** as either **`strong`**, **`weak`**, or **`unowned`**.

    ```swift
    class Singer {
        func playSong() {
            print("Shake it off!")
        }
    }
    ```

    ```swift
    func sing() -> () -> Void {
        let taylor = Singer()

        let singing = {
            taylor.playSong()
            return
        }

        return singing
    }
    ```

    ```swift
    let singFunction = sing()
    singFunction()
    ```

    ### **Strong capturing**

    By **default** **Swift uses `strong` **capturing**. 

    This means **the closure will capture any external values that are used inside the closure, and make sure they never get destroyed.**

    **That `taylor` constant is made inside the `sing()` function, so normally it would be destroyed when the function ends.** 

    **However, it gets used inside the closure, which means Swift will automatically make sure it stays alive for as long as the closure exists somewhere, even after the function has returned.**

    This is strong capturing in action. **If Swift allowed `taylor` to be destroyed, then the closure would no longer be safe to call** – its **`taylor.playSong()`** method wouldn’t be valid any more.

    ### **Weak capturing**

    Weak capturing changes two things:

    1. **Weakly captured values aren’t kept alive by the closure**, so **they might be destroyed** **and** be **set** **to** **`nil`**.
    2. As a result of 1, **weakly captured values are always *optional* in Swift.** This stops you assuming they are present when in fact they might not be.

    We can modify our example to use weak capturing and you’ll see an immediate difference:

    ```swift
    func sing() -> () -> Void {
        let taylor = Singer()

        let singing = { [weak taylor] in
            taylor?.playSong()
            return
        }

        return singing
    }
    ```

    That **`[weak taylor]`** part is **our capture list**, which is a specific part of closures where we **give specific instructions as to how values should be captured.**

    Here we’re saying that **`taylor`** should be captured weakly, which is why we need to use **`taylor?.playSong()`** – it’s an optional now, because it could be set to nil at any time.

    **If you run the code now you’ll see that calling `singFunction()` doesn’t print anything any more. The reason is that `taylor` exists only inside `sing()`, because the closure it returns doesn’t keep a strong hold of it.**

    ### **Unowned capturing**

    Behaves more **like implicitly unwrapped optionals**. **`unowned`** capturing **allows values to become nil at any point in the future**. **However**, you **can work with them as if they are always going to be there** – **you don’t need to unwrap optionals.**

    ```swift
    func sing() -> () -> Void {
        let taylor = Singer()

        let singing = { [unowned taylor] in
            taylor.playSong()
            return
        }

        return singing
    }
    ```

    That will crash.

    **`unowned taylor`** **says I know for sure that `taylor` will always exist for the lifetime of the closure I’m sending back so I don’t need to hold on to the memory, but in practice `taylor` will be destroyed almost immediately so the code will crash.**

    You should use **`unowned`** very carefully indeed.

    ### **Common problems**

    There are four problems folks commonly hit when using closure capturing:

    - **They aren’t sure where to use capture lists when closures accept parameters.**

        **When using capture lists and closure parameters together the capture list must always come first**, then the word **`in`** to mark the start of your closure body – trying to put it *after* the closure parameters will stop your code from compiling.

        ```swift
        writeToLog { [weak self] user, message in 
            self?.addToLog("\(user) triggered event: \(message)")
        }
        ```

    - **They make strong reference cycles, causing memory to get eaten up.**

        When thing **A owns thing B, and thing B owns thing A**, you have what’s called a **strong reference cycle**, or often just a **retain cycle.**

        ```swift
        class House {
            var ownerDetails: (() -> Void)?

            func printDetails() {
                print("This is a great house.")
            }

            deinit {
                print("I'm being demolished!")
            }
        }
        ```

        ```swift
        class Owner {
            var houseDetails: (() -> Void)?

            func printDetails() {
                print("I own a house.")
            }

            deinit {
                print("I'm dying!")
            }
        }
        ```

        ```swift
        print("Creating a house and an owner")

        do {
            let house = House()
            let owner = Owner()
        }

        print("Done")
        ```

        That should print “Creating a house and an owner”, “I’m dying!”, “I'm being demolished!”, then “Done” – everything works as expected.

        ```swift
        print("Creating a house and an owner")

        do {
            let house = House()
            let owner = Owner()
            house.ownerDetails = owner.printDetails
            owner.houseDetails = house.printDetails
        }

        print("Done")
        ```

        Now it will print “Creating a house and an owner” then “Done”, with **neither deinitializer being called.**

        What’s happening here is that **house has a property that points to a method of owner**, **and owner has a property that points to a method of house,** so **neither can be safely destroyed.** 

        In real code **this causes memory that can’t be freed**, known as a **memory leak**, which **degrades system performance and can even cause your app to be terminated.**

        To fix this **we need to create a new closure and use weak capturing for one or both values**, like this:

        ```swift
        print("Creating a house and an owner")

        do {
            let house = House()
            let owner = Owner()
            house.ownerDetails = { [weak owner] in owner?.printDetails() }
            owner.houseDetails = { [weak house] in house?.printDetails() }
        }

        print("Done")
        ```

        **It isn’t necessary to have *both* values weakly captured** – all that matters is that **at least one is**, because it allows Swift to destroy them both when necessary.

    - **They accidentally use strong references, particularly when using multiple captures.**

        ```swift
        func sing() -> () -> Void {
            let taylor = Singer()
            let adele = Singer()

            let singing = { [unowned taylor, adele] in
                taylor.playSong()
                adele.playSong()
                return
            }

            return singing
        }
        ```

        Now **we have two values being captured by the closure**, and both values are being used the same way inside the closure. 

        However, **only `taylor` is being captured as unowned** – **`adele`** **is being captured strongly**, because **the `unowned` keyword must be used for each captured value in the list.**

        Now, if you *want* **`taylor`** to be unowned but **`adele`** to be strongly captured, that’s fine. But if you want *both* to be unowned you need to say so:

        ```swift
        [unowned taylor, unowned adele]
        ```

        Swift does offer *some* protection against accidental capturing, but it’s limited: **if you use `self` implicitly inside a closure, Swift forces you to add `self.` or `self?`. to make your intentions clear.**

        Implicit use of self happens a lot in Swift. For example, this initializer calls **`playSong()`**, but what it *really* means is **`self.playSong()`** – the **`self`** part is implied by the context:

        ```swift
        class Singer {
            init() {
                playSong()
            }

            func playSong() {
                print("Shake it off!")
            }
        }
        ```

        **Swift won’t let you use implicit self inside closures, which helps reduce a common type of retain cycle.**

    - **They make copies of closures and share captured data.**

        ```swift
        var numberOfLinesLogged = 0

        let logger1 = {
            numberOfLinesLogged += 1
            print("Lines logged: \(numberOfLinesLogged)")
        }

        logger1()
        ```

        **If we take a copy of that closure**, **that copy shares the same capturing values as its original**, so **whether we call the original or the copy you’ll see the log line count increasing:**

        ```swift
        let logger2 = logger1
        logger2()
        logger1()
        logger2()
        ```

        **because both `logger1` and `logger2` are pointing at the same captured `numberOfLinesLogged` value.**

    ### **When to use `strong`, when to use `weak`, when to use `unowned`**

    1. **If you know for sure your captured value will never go away while the closure has any chance of being called, you can use** **`unowned`**. This is really only for the handful of times when **`weak`** would cause annoyances to use, but even when you could use **`guard let`** inside the closure with a weakly captured variable.
    2. **If you have a strong reference cycle situation – where thing A owns thing B and thing B owns thing A – then one of the two should use `weak` capturing.** This should **usually be whichever of the two will be destroyed first**, so if view controller A presents view controller B, view controller B might hold a weak reference back to A.
    3. **If there’s no chance of a `strong` reference cycle you can use strong capturing**. For example, **performing animation won’t cause `self` to be retained inside the animation closure, so you can use strong capturing.**

    **If you’re not sure which to use, start out with `weak` and change only if you need to.**

- **Reading from disk: contentsOfFile**

    First, go to the start of your class and **make two new arrays.** 

    We’re going to use the **first one to hold all the words in the input file**, and the **second one will hold all the words the player has currently used in the game.**

    ```swift
    var allWords = [String]()
    var usedWords = [String]()
    ```

    Second, **loading our array**. This is done in **three parts**: **finding the path to our start.txt file**, l**oading the contents of that file**, **then splitting it into an array.**

    ```swift
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
        if let startWords = try? String(contentsOf: startWordsURL) {
            allWords = startWords.components(separatedBy: "\n")
        }
    }

    if allWords.isEmpty {
        allWords = ["silkworm"]
    }
    ```

    We use a built-in method **`Bundle`** to find it: **`path(forResource:)`**. This **takes as its parameters the name of the file** **and its path extension**, and **returns** a **`String?`** – i.e., **you either get the path back or you get `nil` if it didn’t exist.**

    When you create a **`String`** instance, **you can ask it to create itself from the contents of a file at a particular path.**

    Finally, **we need to split our single string into an array of strings** based on wherever we find a line break (\n).

    **`try?`** means "**call this code, and if it throws an error just send me back `nil` instead.**" This means the code you call will always work, but you need to unwrap the result carefully.

    **`isEmpty`** This **returns true if the array is empty**, and **is effectively equal to writing `allWords.count == 0`**. The reason we use **`isEmpty`** is because **some collection type**s, such as string, **have to calculate their size by counting over all the elements they contain**, so reading **`count == 0`** can be **significantly slower than using `isEmpty`.**

    ```swift
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    ```

    Calling **`reloadData()`** **forces it to call `numberOfRowsInSection` again, as well as calling `cellForRowAt` repeatedly.** 

    ```swift
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    ```

- **Pick a word, any word: UIAlertController**

    ```swift
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            self?.submit(answer)
        }

        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    ```

    - **It needs to be called from a `UIBarButtonItem` action, so we must mark it `@objc`.**
    - The **`addTextField()`** method **just adds an editable text input field to the `UIAlertController`**.
    - The **`addAction()`** method is used to add a **`UIAlertAction`** to a **`UIAlertController`**.
    - **`UITextField` is a simple editable text box that shows the keyboard so the user can enter something.**
    - Rather than specifying a `**handler**` parameter, **we pass the code we want to run in braces after the method call.**
    - **We don't make any reference to the** **`action`** **parameter** inside the closure, **which means we don't need to give it a name at all.**
    - **`[weak self, weak ac]`**. That declares **`self`** (the current view controller) and **`ac`** (our **`UIAlertController`**) t**o be captured as weak references inside the closure.** It means the closure can use them, but won't create a strong reference cycle because we've made it clear the closure doesn't own either of them.
    - This **`submit()`** **method is external to the closure’s current context**, so when you're writing it you might not realize that **calling `submit()` implicitly requires that `self` be captured by the closure.** That is, **the closure can't call `submit()` if it doesn't capture the view controller.**
    - **Inside the closure we need to reference methods on our view controller using `self` so that we’re clearly acknowledging the possibility of a strong reference cycle.**