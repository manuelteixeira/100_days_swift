# Day 23 - Milestone: Projects 1-3

- **What you learned**
    - Table views using **`UITableView`**. These are used everywhere in iOS, and are one of the most important components on the entire platform.
    - Image views using **`UIImageView`**, as well as the data inside them, **`UIImage`**. Remember: a **`UIImage`** contains the pixels, but a **`UIImageView`** displays them – i.e., positions and sizes them. You also saw how iOS handles retina and retina HD screens using @2x and @3x filenames.
    - Buttons using **`UIButton`**. These don’t have any special design in iOS by default – they just look like labels, really. But they do respond when tapped, so you can take some action.
    - View controllers using **`UIViewController`**. These give you all the fundamental display technology required to show one screen, including things like rotation and multi-tasking on iPad.
    - System alerts using **`UIAlertController`**. We used this to show a score in project 2, but it’s helpful for any time you need the user to confirm something or make a choice.
    - Navigation bar buttons using **`UIBarButtonItem`**. We used the built-in action icon, but there are lots of others to choose from, and you can use your own custom text if you prefer.
    - Colors using **`UIColor`**, which we used to outline the flags with a black border. There are lots of built-in system colors to choose from, but you can also create your own.
    - Sharing content to Facebook and Twitter using **`UIActivityViewController`**. This same class also handles printing, saving images to the photo library, and more.

    Three important **Interface Builder** things you’ve met so far are:

    1. **Storyboards**, edited using Interface Builder, **but used in code too by setting storyboard identifiers.**
    2. Outlets and action from Interface Builder. **Outlets** **connect views to named properties** (e.g. **`imageView`**), and **actions** **connect them to methods that get run**, e.g. **`buttonTapped()`**.
    3. **Auto Layout to create rules for how elements of your interface should be positioned relative to each other.**

- **Key points**

    ```swift
    let items = try! fm.contentsOfDirectory(atPath: path)
    ```

    The **`fm`** was a reference to **`FileManager`** and **`path`** was a reference to the resource path from **`Bundle`**, so that line pulled out an array of files at the directory where our app’s resources lived. 

    When you ask for the contents of a directory, **it's possible that the directory doesn’t actually exist.** 

    **Maybe you meant to look in a directory called “files” but accidentally wrote “file”.** In this situation, the **`contentsOfDirectory()`** **call will fail, and Swift will throw an exception** – it will literally refuse to continue running your code until you handle the error.

    We didn’t type it in by hand, so if reading from our own app’s bundle doesn’t work then clearly something is very wrong indeed.

    Swift requires any calls that might fail to be called using the **`try`** keyword, **which forces you to add code to catch any errors that might result**. However, because **we know this code will work** – it can’t possibly be mistyped – we can use the **`try!`** keyword.

    ```swift
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    ```

    We changed **`ViewController`** so that it was based on **`UITableViewController`**, which **provides default answers to lots of questions: how many sections are there? How many rows? What’s in each row? What happens when a row is tapped? And so on.**

    Clearly **we don’t want the default answers to each of those questions, because our app needs to specify how many rows it wants based on its own data.** And that’s where the **`override`** keyword comes in: it means “I know there’s a default answer to this question, but I want to provide a new one.” The “question” in this case is “numberOfRowsInSection”, which expects to receive an **`Int`** back: how many rows should there be?

    ```swift
    let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)

    if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
    }
    ```

    Both of these **are responsible for linking code to storyboard information using an identifier string.** In the former case, it’s a cell reuse identifier; in the latter, it’s a view controller’s storyboard identifier. **You always need to use the same name in Interface Builder and your code**.

    The second of those pieces of code is particularly interesting, because of the **`if let`** and **`as? DetailViewController`**. **When we dequeued the table view cell, we used the built-in “Basic” style – we didn’t need to use a custom class to work with it, so we could just crack on and set its text.**

    However, the detail view controller has its own custom thing we need to work with: the **`selectedImage`** string. **That doesn’t exist on a regular `UIViewController`, and that’s what the `instantiateViewController()` method returns** – it doesn’t know (or care) what’s inside the storyboard, after all. That’s where the **`if let`** and **`as?`** typecast comes in: it means “I want to treat this is a **`DetailViewController`** so please try and convert it to one.”

    Only if that conversion works will the code inside the braces execute – and that’s why we can access the **`selectedImage`** property safely.

- **Challenge**

    1. Start with a Single View App template, then change its main **`ViewController`** class so that builds on **`UITableViewController`** instead.
    2. Load the list of available flags from the app bundle. You can type them directly into the code if you want, but it’s preferable not to.
    3. Create a new Cocoa Touch Class responsible for the detail view controller, and give it properties for its image view and the image to load.
    4. You’ll also need to adjust your storyboard to include the detail view controller, including using Auto Layout to pin its image view correctly.
    5. You will need to use **`UIActivityViewController`** to share your flag.