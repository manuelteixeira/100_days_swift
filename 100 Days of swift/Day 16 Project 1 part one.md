# Day 16 - Project 1, part one

- **Setting up**
- **Listing images with FileManager**

    ```swift
    import UIKit

    class ViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view, typically from a nib.
        }
    }
    ```

    - The file starts with **`import UIKit`**, which means “**this file will reference the iOS user interface toolkit**.”
    - The **`class ViewController: UIViewController`** line means “I want to create a new screen of data called ViewController, based on UIViewController.” **When you see a data type that starts with “UI”, it means it comes from UIKit**. **`UIViewController`** is **Apple’s default screen type**, which is empty and white until we change it.
    - The line **`override func viewDidLoad()`** starts a method. As you know, the **`override`** keyword is needed because it means “we want to change Apple’s default behavior from **`UIViewController`**.” **`viewDidLoad()`** is called by UIKit when the screen has loaded, and is ready for you to customize.
    - The **`viewDidLoad()`** method contains one line of code saying **`super.viewDidLoad()`** and one line of comment (that’s the line starting with **`//`**). This **`super`** call means “tell Apple’s **`UIViewController`** to run its own code before I run mine,” and you’ll see this used a lot.

    ```swift
    let fm = FileManager.default
    let path = Bundle.main.resourcePath!
    let items = try! fm.contentsOfDirectory(atPath: path)

    for item in items {
        if item.hasPrefix("nssl") {
            // this is a picture to load!
        }
    }
    ```

    - **`FileManager.default`**. This is a data type that **lets us work with the filesystem**, and in our case we'll be using it to look for files.
    - The line **`let path = Bundle.main.resourcePath!`** declares a constant called **`path`** that is **set to the resource path of our app's bundle.** Remember, a **bundle** is a **directory containing our compiled program and all our assets.** So, this line says, "tell me where I can find all those images I added to my app."
    - The line **`let items = try! fm.contentsOfDirectory(atPath: path)`** declares a third constant called **`items`** that is set to the **contents of the directory at a path**. The **`items`** constant will be an array of strings containing filenames.
    - The line **`for item in items {`** starts a loop that will execute once for every item we found in the app bundle.
    - The line **`if item.hasPrefix("nssl") {`** is the first line inside our loop. By this point, we'll have the first filename ready to work with, and it'll be called **`item`**. To decide whether it's one we care about or not, we use the **`hasPrefix()`** method: it takes one parameter (the prefix to search for) and returns either true or false. That "if" at the start means this line is a conditional statement: if the item has the prefix "nssl", then… that's right, another opening brace to mark another new code block. This time, the code will be executed only if **`hasPrefix()`** returned true.
    - Finally, the line **`// this is a picture to load!`** is a comment – if we reach here, **`item`** contains the name of a picture to load from our bundle, so we need to store it somewhere.
    - In this instance it’s **perfectly fine to use Bundle.main.resourcePath! and try!**, **because** i**f this code fails it means our app can't read its own data** **so something must be seriously wrong.**

    ```swift
    class ViewController: UIViewController {
        
        var pictures = [String]()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
            
            for item in items {
                if item.hasPrefix("nssl") {
                    pictures.append(item)
                }
            }
            print(pictures)
        }
    }
    ```

    The three constants we already created – **`fm`**, **`path`**, and **`items`** – **live inside the viewDidLoad() method**, and **will be destroyed as soon as that method finishes**. What **we want** is a way **to attach data to the whole ViewController** type so that it will exist for as long as our screen exists. So, this a **perfect example of when to use a property.**

- **Designing our interface**

    For this app, our **main user interface component is called `UITableViewController`**. It’s **based on `UIViewController`** but **adds** the **ability** to **show rows of data that can be scrolled and selected**. 

    You can see **`UITableViewController`** in the **Settings** app, in **Mail**, in **Notes**, in **Health**.

    ```swift
    class ViewController: UITableViewController { ... }
    ```

    **`ViewController`** now **inherits its functionality from `UITableViewController` instead of `UIViewController`. Gives us a huge amount of extra functionality.**

    To **make the table show our rows**, **we need to override two behaviors**:

    - **how many rows should be shown**

        ```swift
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return pictures.count
        }
        ```

        - The **`override`** keyword means the method has been defined already, and we want to override the existing behavior with this new behavior. If you didn't override it, then the previously defined method would execute, and in this instance it would say there are no rows.
        - As promised, the next thing to come is **`tableView: UITableView`**, **which is the table view that triggered the code.** But this contains two pieces of information at once: **`tableView`** **is the name** that **we can use to reference the table view inside the method**, and **`UITableView`** is the **data type**.
        - The most important part of the method comes next: **`numberOfRowsInSection section: Int`**. This code will be triggered **when iOS wants to know how many rows are in the table view.** The **`section`** part is there because table views can be split into sections, like the way the Contacts app separates names by first letter. We only have one section, so we can ignore this number.
        - Finally, **`-> Int`** means “this method must return an integer”, which ought to be the number of rows to show in the table.
    - **what each row should contain.**

        ```swift
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
            cell.textLabel?.text = pictures[indexPath.row]
            return cell
        }
        ```

        - **`cellForRowAt indexPath: IndexPath`** is the important part of the method name. **Will be called when you need to provide a row. The row to show is specified in the parameter**: **`indexPath`**.
        - **`-> UITableViewCell`** means this method **must return a table view cell.** If you remember, we created one inside Interface Builder and gave it the identifier “Picture”, so we want to use that.
        - To **save CPU time and RAM**, **iOS only creates as many rows as it needs to work.** **When** one **rows moves off the top of the screen**, **iOS will take it away and put it into a reuse queue ready to be recycled into a new row that comes in from the bottom.** This means you can scroll through hundreds of rows a second, and iOS can behave lazily and avoid creating any new table view cells – it just recycles the existing ones.