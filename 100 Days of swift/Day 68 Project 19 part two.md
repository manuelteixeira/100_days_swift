# Day 68 - Project 19, part two

- **Establishing communication**

    ```swift
    run: function(parameters) {
        parameters.completionFunction({"URL": document.URL, "title": document.title });
    },
    ```

    what it means is "**tell iOS the JavaScript has finished preprocessing, and give this data dictionary to the extension**." The data that is being sent has the keys "URL" and "title", with the values being the page URL and page title.

    ```swift
    guard let itemDictionary = dict as? NSDictionary else { return }
    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
    print(javaScriptValues)
    ```

    **`NSDictionary`** is a new data type, and it’s not really one you have much cause to use in Swift that often because it’s a bit of a holdover from older iOS code. Put simply, **`NSDictionary`** **works like a Swift dictionary, except you don't need to declare or even know what data types it holds**. One of the nasty things about **`NSDictionary`** is that you don't need to declare or even know what data types it holds.

    Yes, it's both an advantage and a disadvantage in one, which is why modern Swift dictionaries are preferred. **When working with extensions, however, it's definitely an advantage because we just don't care what's in there** – we just want to pull out our data.

    When you use **`loadItem(forTypeIdentifier:)`**, your closure will be called with the data that was received from the extension along with any error that occurred. Apple could provide other data too, so what we get is a dictionary of data that contains all the information Apple wants us to have, and we put that into **`itemDictionary`**.

    Right now, there's nothing in that dictionary other than the data we sent from JavaScript, and that's stored in a special key called **`NSExtensionJavaScriptPreprocessingResultsKey`**. So, **we pull that value out from the dictionary, and put it into a value called `javaScriptValues`.**

    We sent a dictionary of data from JavaScript, so we typecast **`javaScriptValues`** as an **`NSDictionary`** again **so that we can pull out values using keys**.

- **Editing multiline text with UITextView**

    We're going to use a new UIKit component called **`UITextView`**. But **if you want multiple lines of text you need `UITextView`.**

    This text view is going to contain code rather than writing, so we don’t want any of Apple’s “helpful” text correction systems in place. To turn them off, select the text view then go to the attributes inspector – you want to to set Capitalization to None, then Correction, Smart Dashes, Smart Insert, Smart Quotes, and Spell Checking all to No.

    open **`ActionViewController.swift`** and add these two properties to your class:

    ```swift
    var pageTitle = ""
    var pageURL = ""
    ```

    ```swift
    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
    self?.pageURL = javaScriptValues["URL"] as? String ?? ""

    DispatchQueue.main.async {
        self?.title = self?.pageTitle
    }
    ```

    That **sets our two properties from the `javaScriptValues` dictionary**, **typecasting them as String**. It then **uses `async()` to set the view controller's title property on the main queue**. This is needed because the closure being executed as a result of loadItem(forTypeIdentifier:) could be called on any thread, and we don't want to change the UI unless we're on the main thread.

    The **`done()`** method was originally called as an action from the storyboard, but we deleted the navigation bar Apple put in because it's terrible. Instead, let's **create a `UIBarButtonItem` in code, and make that call `done()` instead**. Put this in **`viewDidLoad()`**:

    ```swift
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    ```

    function in the Action.js JavaScript file, so we're going to modify the **`done()`** method so that it passes back the text the user entered into our text view.

    To make this work, we need to:

    - Create a new **`NSExtensionItem`** object that **will host our items**.
    - **Create a dictionary containing the key "customJavaScript" and the value of our script.**
    - **Put that dictionary into *another* dictionary** with the key **`NSExtensionJavaScriptFinalizeArgumentKey`**.
    - **Wrap the big dictionary inside** an **`NSItemProvider`** object with the type identifier **`kUTTypePropertyList`**.
    - Place that **`NSItemProvider`** into our **`NSExtensionItem`** **as its attachments.**
    - Call **`completeRequest(returningItems:)`**, returning our **`NSExtensionItem`**.

    ```swift
    @IBAction func done() {
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]

        extensionContext?.completeRequest(returningItems: [item])
    }
    ```

    **That's all the code required to send data back to Safari**, at which point **it will appear inside the `finalize()`** function in Action.js. From there we can do what we like with it, but in this project the JavaScript we need to write is remarkably simple: **we pull the "`customJavaScript`" value out of the parameters array, then pass it to the JavaScript `eval()` function, which executes any code it finds.**

    ```swift
    finalize: function(parameters) {
        var customJavaScript = parameters["customJavaScript"];
        eval(customJavaScript);
    }
    ```

- **Fixing the keyboard: NotificationCenter**

    Before we're done, **there's a bug** in our extension, and it's a bad one – or at least it's bad once you spot it. You see, when you tap to edit a text view, the iOS keyboard automatically appears so that user can start typing. But **if you try typing lots, you'll notice that you can actually type underneath the keyboard because the text view hasn't adjusted its size because the keyboard appeared.**

    **We can ask to be told when the keyboard state changes by using a new class called `NotificationCenter`**. Behind the scenes, iOS is constantly sending out notifications when things happen – keyboard changing, application moving to the background, as well as any custom events that applications post. **We can add ourselves as an observer for certain notifications and a method we name will be called when the notification occurs, and will even be passed any useful information.**

    **When working with the keyboard, the notifications we care about are `keyboardWillHideNotification`** and **`keyboardWillChangeFrameNotification`**. The **first will be sent when the keyboard has finished hiding**, and the s**econd will be shown when any keyboard state change happens** – including showing and hiding, but also orientation, QuickType and more.

    It might sound like we don't need **`keyboardWillHideNotification`** if we have **`keyboardWillChangeFrameNotification`**, but in my testing just using **`keyboardWillChangeFrameNotification`** isn't enough to catch a hardware keyboard being connected. Now, that's an extremely rare case, but we might as well be sure!

    **To register ourselves as an observer for a notification, we get a reference to the default notification center**. We **then use the `addObserver()` method**, which **takes four parameters**: the **object that should receive notifications** (it's self), the m**ethod that should be called**, the **notification we want to receive**, and **the object we want to watch**. We're going to pass nil to the last parameter, meaning "we don't care who sends the notification."

    ```swift
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    ```

    When working with keyboards, the dictionary will contain a key called **`UIResponder.keyboardFrameEndUserInfoKey`** t**elling us the frame of the keyboard after it has finished animating**. This will be of type **`NSValue`**, which in turn is of type **`CGRect`**. The **`CGRect`** struct holds both a **`CGPoint`** and a **`CGSize`**, so it can be used to describe a rectangle.

    One of the quirks of Objective-C was that arrays and dictionaries couldn't contain structures like **`CGRect`**, so Apple had a special class called **`NSValue`** that acted as a wrapper around structures so they could be put into dictionaries and arrays. That's what's happening here: we're getting an **`NSValue`** object, but we know it contains a **`CGRect`** inside so we use its **`cgRectValue`** property to read that value.

    Once we finally pull out the correct frame of the keyboard, we need to convert the rectangle to our view's co-ordinates. This is because rotation isn't factored into the frame, so if the user is in landscape we'll have the width and height flipped – using the convert() method will fix that.

    The next thing we need to do in the adjustForKeyboard() method is **to adjust the `contentInset` and `scrollIndicatorInsets` of our text view.** These two **essentially indent the edges of our text view so that it appears to occupy less space even though its constraints are still edge to edge in the view.**

    Finally, we're going to **make the text view scroll so that the text entry cursor is visible**. If the text view has shrunk this will now be off screen, so scrolling to find it again keeps the user experience intact.

    ```swift
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        script.scrollIndicatorInsets = script.contentInset

        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    ```