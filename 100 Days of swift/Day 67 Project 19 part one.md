# Day 67 - Project 19, part one

- **Making a shell app**

    **Safari extensions are launched from within the Safari action menu, but they ship inside a parent app**. That is, you can't ship an extension by itself – it needs have an app alongside it. Frequently the app does very little, but it must at least be present.

- **Adding an extension: NSExtensionItem**

    To get started with a fresh extension, go to the File menu and choose **New > Target**. When you're asked to choose a template, select **iOS > Application Extension > Action Extension**, then click Next. For the name just call it Extension, make sure **Action Type is set to "Presents User Interface",** then click Finish.

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // do stuff!
                }
            }
        }
    }
    ```

    - When our extension is created, its **`extensionContext`** **lets us control how it interacts with the parent app**. In the case of **`inputItems`** this will be an **array of data the parent app is sending to our extension to use**. We only care about this first item in this project, and even then it might not exist, so we conditionally typecast using **`if let`** and **`as?`**.
    - Our **input item contains an array of attachments**, which are given to us wrapped up as an **`NSItemProvider`**. Our code pulls out the first attachment from the first input item.
    - The next line uses **`loadItem(forTypeIdentifier: )`** to **ask the item provider to actually provide us with its item**, but you'll notice it uses a closure so **this code executes asynchronously**. That is, the method will carry on executing while the item provider is busy loading and sending us its data.
    - Inside our closure we first need the usual **`[weak self]`** to avoid strong reference cycles, but we also **need to accept two parameters: the dictionary that was given to us by the item provider, and any error that occurred.**
    - With the item successfully pulled out, we can get to the interesting stuff: working with the data.
- **What do you want to get?**

    For extensions, this **plist also describes what data you are willing to accept and how it should be processed**.

    Open up the disclosure arrow for **`NSExtensionAttributes`** and you should see **`NSExtensionActivationRule`**, then String, then TRUEPREDICATE. **Change String to be Dictionary**, then open its disclosure arrow and click the small + button to the left of “Dictionary”, and when it asks you for a **key name** change "New item" to be "**`NSExtensionActivationSupportsWebPageWithMaxCount`**". You can leave the new item as a string (it doesn't really matter), but **change its value to be `1`** – that's the empty space just to the right of String.

    Adding this value to the dictionary **means that we only want to receive web pages** – we aren't interested in images or other data types.

    Now select the **`NSExtensionAttributes`** line itself, and **click the +** button that appears next to the word Dictionary. **Replace "New item"** with "**`NSExtensionJavaScriptPreprocessingFile`**", then **give it the value "`Action`".** This tells iOS that **when our extension is called, we need to run the JavaScript preprocessing file called `Action.js`,** which will be in our app bundle. Make sure you type "Action" and not "Action.js", because iOS will append the ".js" itself.

    Right-click on your extension's Info.plist file and choose New File. When you're asked what template you want, choose iOS > Other > Empty, then name it Action.js, and put this text into it:

    ```swift
    var Action = function() {};

    Action.prototype = {

    run: function(parameters) {

    },

    finalize: function(parameters) {

    }

    };

    var ExtensionPreprocessingJS = new Action
    ```

    - There are two functions: **`run()`** and **`finalize()`**. The first is called before your extension is run, and the other is called after.
    - Apple expects the code to be exactly like this, so you shouldn't change it other than to fill in the **`run()`** and **`finalize()`** functions.