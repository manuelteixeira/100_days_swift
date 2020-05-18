# Day 43 - Project 10, part two

- **Importing photo with UIImagePicketController**

    This new class is designed to **let users select an image from their camera to import into an app.** When you first create a **`UIImagePickerController`**, iOS will automatically ask the user whether the app can access their photos.

    ```swift
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    ```

    The **`addNewPerson()`** method **is where we need to use the UIImagePickerController**

    ```swift
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    ```

    1. We set the **`allowsEditing`** property to be true, which **allows the user to crop the picture they select.**
    2. When you set **`self`** as the delegate, you'll **need to conform not only to the `UIImagePickerControllerDelegate` protocol, but also the `UINavigationControllerDelegate` protocol.**
    3. The whole method is being called from Objective-C code using **`#selector`**, so we need to use the **`@objc`** attribute. This is the last time I’ll be repeating this, but hopefully you’re mentally always expecting **`#selector`** to be paired with **`@objc`**.

    ```swift
    class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    ```

    **`UIImagePickerControllerDelegate`** protocol, you **don't need to add any methods because both are optional.** But they aren't really – they are marked optional for whatever reason, **but your code isn't much good unless you implement at least one of them!**

    The delegate method we care about is **`imagePickerController(_, didFinishPickingMediaWithInfo:)`**, which **returns when the user selected an image and it's being returned to you. This method needs to do several things:**

    - Extract the image from the dictionary that is passed as a parameter.
    - Generate a unique filename for it.
    - Convert it to a JPEG, then write that JPEG to disk.
    - Dismiss the view controller.

    First, **it's very common for Apple to send you a dictionary of several pieces of information as a method parameter**. This can be hard to work with sometimes because you need to know the names of the keys in the dictionary in order to be able to pick out the values, but you'll get the hang of it over time.

    This **dictionary parameter will contain one of two keys**: **`.editedImage`** (the image that was edited) or **`.originalImage`**, but in our case **it should only ever be the former unless you change the allowsEditing property**.

    The problem is, we don't know if this value exists as a **`UIImage`**, so we can't just extract it. Instead, we need to use an optional method of typecasting, as?, along with if let. Using this method, we can be sure we always get the right thing out.

    Second, **we need to generate a unique filename for every image we import.** This is **so that we can copy it to our app's space on the disk without overwriting anything**, **and if the user ever deletes the picture from their photo library we still have our copy. We're going to use** a new type for this, called **`UUID`**, which **generates a Universally Unique Identifier and is perfect for a random filename.**

    Third, once we have the image, we need to write it to disk. You're going to need to learn two new pieces of code: **`UIImage`** **has a `jpegData()`** to **convert it to a `Data` object in JPEG image format**, and **there's a method on Data called `write(to:)`** that, well, **writes its data to disk.** We used Data earlier, but as a reminder it’s a relatively simple data type that can hold any type of binary type – image data, zip file data, movie data, and so on.

    **All apps that are installed have a directory called Documents where you can save private information for the app**, and **it's also automatically synchronized with iCloud**. The problem is, it's not obvious how to find that directory, so I have a method I use called `**getDocumentsDirectory()**` that does exactly that.

    ```swift
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }

        dismiss(animated: true)
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    ```

    The first parameter of **`FileManager.default.urls`** **asks for the documents directory,** and its **second parameter adds that we want the path to be relative to the user's home directory**. This returns an array that nearly always contains only one thing: the user's documents directory. So, we pull out the first element and return it.

    I’ve used **`guard`** to **pull out and typecast the image from the image picker**, because **if that fails we want to exit the method immediately.** We **then create an UUID object**, and **use its uuidString property to extract the unique identifier as a string data type.**

    The code then creates a new constant, **`imagePath`**, which takes the URL result of **`getDocumentsDirectory()`** and calls a new method on it: **`appendingPathComponent()`**. This **is used when working with file paths, and adds one string** (imageName in our case) **to a path**, including whatever path separator is used on the platform.

    Now that we have a UIImage containing an image and a path where we want to save it, **we need to convert the `UIImage` to a `Data` object so it can be saved.** To do that, **we use the `jpegData()`** method, which takes one parameter: a quality value between 0 and 1, where 1 is “maximum quality”.

    Once we have a Data object containing our JPEG data, we just **need to unwrap it safely then write it to the file name we made earlier.** That's done **using the `write(to:)`** method, which takes a filename as its parameter.

- **Custom subclasses of NSObject**

    So far you've seen how we can create arrays of strings by using [String], but what if we want to hold an array of people?

    the solution is to create a custom class. Create a new file and choose Cocoa Touch Class. Click Next and name the class “Person”, type “NSObject” for "Subclass of", then click Next and Create to create the file.

    **`NSObject`** is what's **called a universal base class for all Cocoa Touch classes.** That means **all UIKit classes ultimately come from NSObject, including all of UIKit**. **You don't have to inherit from NSObject in Swift**, but you did in Objective-C and in fact **there are some behaviors you can only have if you do inherit from it.**

    Swift is telling us **that we aren't satisfying one of its core rules:** **objects of type String can't be empty**. Remember, String! and String? can both be nil, but plain old String can't – it must have a value. **Without an initializer, it means the object will be created and these two variables won't have values, so you're breaking the rules.**

    ```swift
    class Person: NSObject {
        var name: String
        var image: String
        
        init(name: String, image: String) {
            self.name = name
            self.image = image
        }
    }
    ```

    Every time we add a new person, we need to create a new **`Person`** object with their details. This is as easy as modifying our initial image picker success method so that it creates a **`Person`** object, adds it to our people array, then reloads the collection view. Put this code before the call to **`dismiss()`**

    ```swift
    let person = Person(name: "Unknown", image: imageName)
    people.append(person)
    collectionView.reloadData()
    ```

- **Connecting up the people**

    ```swift
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    ```

    We **need to update the collection view's cellForItemAt method so that it configures each PersonCell cell to have the correct name and image of the person in that position in the array.**

    - Pull out the person from the **`people`** array at the correct position.
    - Set the **`name`** label to the person's name.
    - Create a **`UIImage`** from the person's image filename, adding it to the value from **`getDocumentsDirectory()`** so that we have a full path for the image.

    We're also going to use this opportunity to **give the image views a border and slightly rounded corners**, then **give the whole cell matching rounded corners**, to make it all look a bit more interesting. **This is all done using `CALayer`, so that means we need to convert the `UIColor` to a `CGColor`**. 

    ```swift
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }

        let person = people[indexPath.item]

        cell.name.text = person.name

        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)

        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7

        return cell
    }
    ```

    First, notice how I’ve **used `indexPath.item` rather than indexPath.row,** **because collection views don’t really think in terms of rows.**

    Second, **that code sets the `cornerRadius` property**, **which rounds the corners of a `CALayer`** – **or in our case the `UIView` being drawn by the `CALayer`.**

    Third, I snuck in a **new `UIColor` initializer: `UIColor(white:alpha:)`**. This is **useful when you only want grayscale colors.**

    First, the delegate method **we're going to implement is the collection view’s `didSelectItemAt` method**, which is **triggered when the user taps a cell**. This method needs to pull out the Person object at the array index that was tapped, then show a **`UIAlertController`** asking users to rename the person.

    Adding a text field to an alert controller is done with the addTextField() method. We'll also **need to add two actions**: **one to cancel the alert**, **and one to save the change**. To save the changes, we need to add a closure that pulls out the text field value and assigns it to the person's name property, then we'll also need to reload the collection view to reflect the change.

    ```swift
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]

        let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()

        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName

            self?.collectionView.reloadData()
        })

        present(ac, animated: true)
    }
    ```