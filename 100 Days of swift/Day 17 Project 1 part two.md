# Day 17 - Project 1, part two

- **Building a detail screen**

    **`UIImageView`**. this is a part of UIKit (hence the “UI”), and is **responsible for viewing images**

    **Auto Layout**: it lets you **define rules for how your views should be laid out**, and it **automatically makes sure those rules are followed.**

    It has **two rules** of its own, both of which **must be followed** by you:

    - **Your layout rules must be complete**

        You **can't specify only an X position for something**, **you must also specify a Y position.** 

        **X** is **position from the left** of the screen, and **Y** is position **from** **the top** of the screen.

    - **Your layout rules must not conflict**

        You **can't specify that a view must be 10 points away from the left edge, 10 points away from the right edge, and 1000 points wide.** 

        An iPhone 5 screen is only 320 points wide, so your layout is mathematically impossible. 

        Auto Layout will try to recover from these problems by breaking rules until it finds a solution, but the end result is never what you want.

    ```swift
    class DetailViewController: UIViewController {
        @IBOutlet var imageView: UIImageView!

        override func viewDidLoad() {
            super.viewDidLoad()
    		}
    }
    ```

    - **`@IBOutlet`**: This attribute is **used to tell Xcode that there's a connection between this line of code and Interface Builder.**
    - **`var`**: This declares a new variable or variable property.
    - **`imageView`**: This was the property name assigned to the **`UIImageView`**.
    - **`UIImageView!`**: This declares the property to be of type **`UIImageView`**, and again we see the **implicitly unwrapped** optional symbol: **`!`**. This means that that **`UIImageView`** **may be there or it may not be there**, but we're certain it definitely will be there by the time we want to use it.
        - **when the detail view controller is being created, its view hasn't been loaded yet** – it's just some code running on the CPU.
        - When the basic stuff has been done (allocating enough memory to hold it all, for example), iOS goes ahead and loads the layout from the storyboard, then connects all the outlets from the storyboard to the code.
        - So, **when the detail controller is first made**, the **`UIImageView`** **doesn't exist because it hasn't been created yet** – **but we still need to have some space for it in memory.**
        - At this point, the property is **`nil`**, or just some empty memory. But **when the view gets loaded and the outlet gets connected, the `UIImageView` will point to a real `UIImageView`**, not to **`nil`**, so we can start using it.

- **Loading images with UIImage**

    The next goal is to **show the detail screen when any table row is tapped**, **and** have it **show the selected image.**

    To make this work we need to add another specially named method to **`ViewController`**. This one is called **`tableView(_, didSelectRowAt:)`**, which takes an **`IndexPath`** value just like **`cellForRowAt`** that tells us what row we’re working with. This time we need to do a bit more work:

    - We need to create a property in **`DetailViewController`** that will hold the name of the image to load.

        This property will be a string but it **needs** to be an **optional string** **because when the view controller is first created it won’t exist**. 

        We’ll be setting it straight away, but it still starts off life empty.

        ```swift
        var selectedImage: String?
        ```

    - We’ll implement the **`didSelectRowAt`** method so that it loads a **`DetailViewController`** from the storyboard.

        When we created the detail view controller, you gave it the **storyboard ID “Detail”**, which **allows** **us to load it from the storyboard** **using** a method called **`instantiateViewController(withIdentifier:)`**. **Every view controller has a property called storyboard** **that** i**s either the storyboard it was loaded from or nil**. 

        **They also have an optional navigationController** **property** that **contains the navigation controller they are inside if it exists**, or nil otherwise.

        By **tapping** **Back** or by swiping from left to right – the **navigation controller will automatically destroy the old view controller and free up its memory.**

        ```swift
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            // 1: try loading the "Detail" view controller and typecasting it to be DetailViewController
            if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
                // 2: success! Set its selectedImage property
                vc.selectedImage = pictures[indexPath.row]

                // 3: now push it onto the navigation controller
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        ```

    - Finally, we’ll fill in **`viewDidLoad()`** inside **`DetailViewController`** so that it loads an image into its image view based on the name we set earlier.

        When you create a **`UIImage`**, it **takes** a **parameter** called **`named`** **that lets you specify the name of the image to load.** 

        **`UIImage`** then **looks for this filename in your app's bundle, and loads it.** 

        By passing in the **`selectedImage`** property here, which was sent from ViewController, this will load the image that was selected by the user.

        ```swift
        if let imageToLoad = selectedImage {
            imageView.image  = UIImage(named: imageToLoad)
        }
        ```

- **Final tweaks: hidesBarsOnTap, safe area margins**
    - **Aspect Fit**

        sizes the image so that it's **all visible**. 

    - **Scale to Fill**

        which sizes the image so that **there's no space left blank by stretching it on both axes**. 

    - **Aspect Fill**

        the image effectively **hangs outside its view area**, so **you should make sure you enable Clip To Bounds to avoid the image overspilling.**

    On **`UINavigationController`** theres a property called **`hidesBarsOnTap`**. **When** this is **set to true**, **the user can tap anywhere on the current view controller to hide the navigation bar, then tap again to show it.**

    **Be warned**: you need to set it carefully when working with iPhones. **If we had it set on all the time then it would affect taps in the table view, which would cause havoc when the user tried to select things.** So, **we need to enable it when showing the detail view controller, then disable it when hiding.**

    **There are several others that get called when the view is about to be shown, when it has been shown, when it's about to go away, and when it has gone away.** These are called, respectively, **`viewWillAppear()`**, **`viewDidAppear()`**, **`viewWillDisappear()`** and **`viewDidDisappear()`**.

    ```swift
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    ```

    We’re using the **`navigationController`** property again, **which will work fine because we were pushed onto the navigation controller stack from `ViewController`.** We’re accessing the property using **`?`**, so **if somehow we weren’t inside a navigation controller** the **`hidesBarsOnTap`** l**ines will do nothing.**

    If you look at other apps that use table views and navigation controllers to display screens (again, Settings is great for this), **you might notice gray arrows at the right of the table view cells**. **This is called a disclosure indicator**, and it’s a **subtle user interface hint that tapping this row will show more** information.

    We’re going to **place some text in the gray bar at the navigation bar.** **`UIViewController`** also **have a title property** **that automatically gets read by navigation controller.**

    **`title`** **is optional** because **it’s nil by default**: view controllers have no title, thus showing no text in the navigation bar.

    ```swift
    title = "Storm Viewer"
    ```

    ### Large titles

    One of **Apple’s design guidelines is the use of large titles**.

    ```swift
    // ViewController.swift
    navigationController?.navigationBar.prefersLargeTitles = true
    ```

    **That enables large titles across our app.**

    **Apple** **recommends you use large titles only when it makes sense**, and **that usually means only on the first screen of your app.**

    The default **behavior when enabled is to have large titles everywhere**, but that’s because each new view controller that pushed onto the navigation controller stack inherits the style of its predecessor.

    ```swift
    // DetailViewController.swift
    navigationItem.largeTitleDisplayMode = .never
    ```