# Day 19 - Project 2, part one

- **Setting up**

- **Designing your layout**

    ```swift
    class ViewController: UIViewController {

        @IBOutlet var button1: UIButton!
        @IBOutlet var button2: UIButton!
        @IBOutlet var button3: UIButton!
        
        override func viewDidLoad() {
            super.viewDidLoad()
        }

    }
    ```

- **Making the basic game work: UIButton and CALayer**

    We're going to create an **array of strings** that will **hold all the countries** that will be used for our game, and at the same time we're going to create another property that will **hold the player's current score**

    ```swift
    var countries = [String]()
    var score = 0
    ```

    Add all the countries

    We can also use the **`append`** method.

    ```swift
    countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
    ```

    Method that **shows three random flag images on the screen**. Buttons have a **`setImage()`** method that **lets us control what picture is shown inside** and when, so **we can use that with `UIImage` to display our flags.**

    ```swift
    func askQuestion() {
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }
    ```

    - **`button1.setImage()`** assigns a **`UIImage`** to the button. We have the US flag in there right now, but this will change it when **`askQuestion()`** is called.
    - **`for: .normal`** The **`setImage()`** method takes a second parameter that describes which **state** of the button should be changed. We're specifying **`.normal`**, which means "the standard state of the button."

    One of the many powerful things about **views in iOS** is that they **are** **backed** **by** what's called a **`CALayer`**, which is a **Core Animation data type responsible for managing the way your view looks.**

    Conceptually, **`CALayer`** sits beneath all your **`UIView`**s (that's the parent of **`UIButton`**, **`UITableView`**, and so on), so it's like an exposed underbelly **giving you lots of options for modifying the appearance of views**, as long as you don't mind dealing with a little more complexity.

    ```swift
    button1.layer.borderWidth = 1
    button2.layer.borderWidth = 1
    button3.layer.borderWidth = 1

    button1.layer.borderColor = UIColor.lightGray.cgColor
    button2.layer.borderColor = UIColor.lightGray.cgColor
    button3.layer.borderColor = UIColor.lightGray.cgColor
    ```

    **`CALayer`** sits at a **lower technical level than** **`UIButton`**, which means it **doesn't understand what** a **`UIColor`** is. 

    **`UIButton`** knows what a **`UIColor`** is because they are both at the same technical level, but **`CALayer`** is below **`UIButton`**, so **`UIColor`** is a mystery.

    **`CALayer`** has its own way of setting colors called **`CGColor`**, which comes from Apple's Core Graphics framework.

    **`UIColor`** is able to convert to and from **`CGColor`** easily, which means you don't need to worry about the complexity.