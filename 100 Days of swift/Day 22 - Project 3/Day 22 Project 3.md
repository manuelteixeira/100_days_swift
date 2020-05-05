# Day 22 - Project 3

- **UIActivityViewController explained**

    **`UIActivityViewController`** you tell it what kind of data you want to share, and it figures out how best to share it.

    ```swift
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    ```

    This navigation item **is used by the navigation bar so that it can show relevant information**. In this case, **we're setting the right bar button item,** which is a **button that appears on the right of the navigation bar** when this view controller is visible.

    **`UIBarButtonItem`** data type. 

    The **system item** we specify is **`.action`** displays an arrow coming out of a box, signaling the user can do something when it's tapped.

    The **`action`** parameter is saying "**when you're tapped, call the `shareTapped()` method**" and the **`target`** parameter **tells the button that the method belongs to the current view controller** – **`self`**.

    ```swift
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }

        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    ```

    - **`@objc`** because **this method will get called by the underlying Objective-C operating system** (the **`UIBarButtonItem`**) so we **need to mark it as being available to Objective-C code**. When you call a method using **`#selector`** you’ll always need to use **`@objc`** too.
    - Our **image view may or may not have an image inside**, so we’ll read it out safely and convert it to JPEG data. This has a **`compressionQuality`** parameter where you can specify a value between 1.0 (maximum quality) and 0.0 (minimum quality).
    - Next we create a **`UIActivityViewController`**, which is the iOS method of sharing content with other apps and services.
    - Finally, we tell iOS where the activity view controller should be anchored – where it should appear from.
        - On **iPhone**, **activity view controllers automatically take up the full screen**, **but** on **iPad** **they appear as a popover that allows the user to see what they were working on below.**
        - This line of code tells iOS to **anchor the activity view controller to the right bar button item** (our share button), but this only has an effect on iPad – on iPhone it's ignored.

    **Tip:** In case you were wondering, when you use **`@IBAction`** to make **storyboards call your code, that automatically implies** **`@objc`** – Swift knows that no **`@IBAction`** makes sense unless it can be called by Objective-C code.

    There’s one small but important **bug** with the current code: **if you select Save Image inside the activity view controller, you’ll see the app crashes immediately.** 

    What’s happening here is that **our app tries to access the user’s photo library so it can write the image there, but that isn’t allowed on iOS unless the user grants permission first.**

    To fix this **we need to edit the Info.plist** file for our project. We haven’t touched this yet, but **it’s designed to hold configuration settings for your app that won’t ever change over time.**

    What I’d like you to do is scroll down in that list and **find the name “Privacy - Photo Library Additions Usage Description”.** **This is what will be shown to the user when your app needs to add to their photo library.**

    When you select “Privacy - Photo Library Additions Usage Description” you’ll see “String” appear to the right of it, and to the right of “String” will be an empty white space. **That white space is where you can type some text to show to the user that explains what your app intends to do with their photo library.**

    ![Day%2022%20Project%203/Untitled.png](Day%2022%20Project%203/Untitled.png)

- **Challenges**
    1. Try adding the image name to the list of items that are shared. The **`activityItems`** parameter is an array, so you can add strings and other things freely. Note: Facebook won’t let you share text, but most other share options will.

        ```swift
        @objc func shareTapped() {
            guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
                print("No image found")
                return
            }
            
            let title = selectedImage
            
            let activityController = UIActivityViewController(activityItems: [image, title], applicationActivities: [])
            
            activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            
            present(activityController, animated: true)
        }
        ```

    2. Go back to project 1 and add a bar button item to the main view controller that recommends the app to other people.

        ```swift
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAppTapped))
        ```

        ```swift
        @objc func shareAppTapped() {
            let message = "Hey you should look at this app."
            
            let activityController = UIActivityViewController(activityItems: [message], applicationActivities: [])
            
            navigationController?.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
            
            present(activityController, animated: true)
        }
        ```

    3. Go back to project 2 and add a bar button item that shows their score when tapped.

        ```swift
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action:  #selector(showScore))
        ```

        ```swift
        @objc func showScore() {
            let title = "Score"
            let message = "Your score is \(score)"
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(action)
            
            present(alertController, animated: true)
        }
        ```