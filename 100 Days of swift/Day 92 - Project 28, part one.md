# Day 92 - Project 28, part one

- **The basic text editor**

    Open Main.storyboard in Interface Builder, and embed the default view controller inside a navigation controller. Now place a text view inside (*not* a text field!) so that it fills up most of the space: it should touch the left and right edges of our view, go up to the bottom of the navigation bar, then go down to the bottom of the safe area – that’s where IB will snap to when you drag near the virtual home indicator at the bottom of the view controller. We don’t need anything special for our Auto Layout constraints, so just go to Editor > Resolve Auto Layout Issues > Add Missing Constraints to place them automatically.

    **Delete the "Lorem ipsum" text in the text view**, then use the assistant editor to **make an outlet for it** called **`secret`**. That's us done with the storyboard for now; switch back to the standard editor and open ViewController.swift.

    We need to add the same code we used in project 19 to make the text view adjust its content and scroll insets when the keyboard appears and disappears. This code is identical apart from the outlet is called **`secret`** now.

    First, put this into **`viewDidLoad()`**:

    ```swift
    let notificationCenter = NotificationCenter.default
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    ```

    As a reminder, **that asks iOS to tell us when the keyboard changes or when it hides**. As a double reminder: **the hide is required because we do a little hack to make the hardware keyboard toggle work correctly** – see project 19 if you don't remember why this is needed.

    Here's the **`adjustKeyboard()`** method, which again is identical apart from the outlet name to that seen in project 19:

    ```swift
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    ```

    None of that is new, so you're probably bored by now. Not to worry: we're going to fix up our storyboard in preparation for authentication, so re-open Main.storyboard.

    **Place a button over the text view,** **give it the title "Authenticate" and make it 44 points high**. For constraints, give it a fixed height constraint, then make it align horizontally and vertically with its superview. Now use the assistant editor to create an action for it called “authenticateTapped”.

    Before you leave Interface Builder, you need to do something we haven't done yet, which is to **move views backwards and forwards relative to each other**. When the user has authenticated, we need to show the text box while making sure the button is no longer visible, and the easiest way to do that is to **place the button behind the text view so that when the text is visible it covers up the button**.

    **To move the text view to the front, select the Authenticate button in the document outline then drag it *above* the text view**. When you do this the button will disappear on the canvas, but that's OK – it's still there, and we can still use it.

    **The last thing to do is ensure the text view starts life hidden**, so select it in Interface Builder, **choose the attributes inspector, and check the Hidden box** – it's near the bottom, not far below Tag. That's our layout complete!

- **Writing somewhere safe: the iOS keychain**

    When the app first runs, users should see a totally innocuous screen, with nothing secret visible. But we also don't want secret information to be visible when the user leaves the app for a moment then comes back, or if they double-tap the home button to multitask – doing so might mean that the app is left unlocked, which is the last thing we want.

    To make this work, let's start by giving the view controller a totally innocuous title that absolutely won't make anyone wonder what's going on. Put this into **`viewDidLoad()`**:

    ```swift
    title = "Nothing to see here"
    ```

    Next we're going to create two new methods: **`unlockSecretMessage()`** to **load the message into the text view**, and **`saveSecretMessage()`**. But before we do that, I want to introduce you to a helpful class called **`KeychainWrapper`**, **which we'll be using to read and write keychain values.**

    **This class was not made by Apple; instead, it's open source software released under the MIT license**, which means we can use it in our own projects as long as the copyright message remains intact. This class is needed because working with the keychain is *complicated* – far harder than anything we have done so far. **So instead of using it directly, we'll be using this wrapper class that makes the keychain work like `UserDefaults`.**

    If you haven't already downloaded this project's files from GitHub ([https://github.com/twostraws/HackingWithSwift](https://github.com/twostraws/HackingWithSwift)), please do so now. In there you'll find the files KeychainWrapper.swift and KeychainItemAccessibility.swift; please copy them into your Xcode project to make the class available.

    The first of our two new methods, **`unlockSecretMessage()`**, **needs to show the text view, then load the keychain's text into it**. **Loading strings from the keychain using** **`KeychainWrapper`** is as simple as using its **`string(forKey:)`** method, but **the result is optional so you should unwrap it once you know there's a value there**.

    Here it is:

    ```swift
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"

        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
    }
    ```

    If you prefer, you can use nil coalescing to provide the default value of an empty string, like this:

    ```swift
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"

        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    ```

    Use whichever you prefer!

    The second of our two new methods, **`saveSecretMessage()`**, **needs to write the text view's text to the keychain, then make it hidden**. This is done using the **`set()`** method of **`KeychainWrapper`**, so it's just as easy as reading. **Note that we should only execute this code if the text view is visible, otherwise if a save happens before the app is unlocked then it will overwrite the saved text!**

    Here's the code:

    ```swift
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }

        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    ```

    I slipped a new method in there: **`resignFirstResponder()`**. **This is used to tell a view that has input focus that it should give up that focus**. Or, in Plain English, **to tell our text view that we're finished editing it, so the keyboard can be hidden**. This is important because having a keyboard present might arouse suspicion – as if our rather obvious navigation bar title hadn't done enough already…

    Now, there are still two questions remaining: how should users trigger a save when they are ready, and how do we ensure that as soon as the user starts to leave the app we make their data safe? For the first problem, consider this: how often do you see a save button in iOS? Hardly ever, I expect!

    It turns out that one answer solves both problems: **if we automatically save when the user leaves the app then the user need never worry about saving because it's done for them, and our save method above automatically hides the text when it's called so the app becomes safe as soon as any action is taken to leave it.**

    We're already using **`NotificationCenter`** to watch for the keyboard appearing and disappearing, and **we can watch for another notification that will tell us when the application will stop being active** – i.e., **when our app has been backgrounded or the user has switched to multitasking mode**. This notification is called **`UIApplication.willResignActiveNotification`**, and you should make us an observer for it in **`viewDidLoad()`** like this:

    ```swift
    notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    ```

    That calls our **`saveSecretMessage()`** **directly when the notification comes in, which means the app automatically saves any text and hides it when the app is moving to a background state**.

    The last thing to do before the app is actually useful is to make tapping the button call **`unlockSecretMessage()`**, like this:

    ```swift
    @IBAction func authenticateTapped(_ sender: Any) {
        unlockSecretMessage()
    }
    ```

- **Touch to activate: Touch ID, Face ID and LocalAuthentication**

    **Touch ID and Face ID are part of the Local Authentication framework**, and our code needs to do three things:

    1. **Check whether the device is capable of supporting biometric authentication** – that the hardware is available and is configured by the user.
    2. If so, **request that the biometry system begin a check now, giving it a string containing the reason why we're asking**.
        1. For **Touch ID the string is written in code**; 
        2. for **Face ID the string is written into our Info.plist file**.
    3. **If we get success** back from the authentication request it means this is the device's owner so **we can unlock the app, otherwise we show a failure message.**

    **One caveat** that you must be careful of: **when we're told whether Touch ID/Face ID was successful or not, it might not be on the main thread**. This means **we need to use `async()` to make sure we execute any user interface code on the main thread.**

    The job of task 1 is done by the **`canEvaluatePolicy()`** **method of the `LAContext` class, requesting the security policy type `.deviceOwnerAuthenticationWithBiometrics`**. 

    The job of task 2 is done by the **`evaluatePolicy()`** of that same class, **using the same policy type, but it accepts a trailing closure telling us the result of the policy evaluation**: was it successful, and if not what was the reason?

    Like I said, all this is provided by the Local Authentication framework, so the first thing we need to do is import that framework. Add this above **`import UIKit`**:

    ```swift
    import LocalAuthentication
    ```

    And now here's the new code for the **`authenticateTapped()`** method. We already walked through what it does, so this shouldn't be too surprising:

    ```swift
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [weak self] success, authenticationError in

                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                    } else {
                        // error
                    }
                }
            }
        } else {
            // no biometry
        }
    }
    ```

    There is one important new piece of syntax in there that we haven’t used before, which is **`&error`**. **The LocalAuthentication framework uses the Objective-C approach to reporting errors back to us**, **which is where the `NSError` type comes from** – where Swift likes to have an enum that conforms to the **`Error`** protocol, Objective-C had a dedicated **`NSError`** type for handling errors.

    Here, though, **we want LocalAuthentication to tell *us* what went wrong, and it can’t do that by returning a value from** the **`canEvaluatePolicy()`** method – **that already returns a Boolean telling us whether biometric authentication is available or not**. So, instead what **we use is the Objective-C equivalent of Swift’s `inout` parameters: we pass an empty `NSError` variable into our call to `canEvaluatePolicy()`, and if an error occurs that error will get filled with a real `NSError` instance telling us what went wrong.**

    Objective-C’s **equivalent to `inout` is what’s called a *pointe**r*, so named because it effectively points to a place in memory where something exists rather us passing around the actual value instead. If we had passed **`error`** into the method, it would mean “here’s the error you should use.” By passing in **`&error`** – Objective-C’s equivalent of **`inout`** – it means “if you hit an error, here’s the place in memory where you should store that error so I can read it.”

    I hope you can now see this is another example of why Swift was such a leap forward compared to Objective-C – having to pass around pointers to things wasn’t terribly pleasant!

    Apart from that, there are a couple of reminders: we need **`[weak self]`** inside the first closure but not the second because it's already weak by that point. You also need to use **`self?.`** inside the closure to make capturing clear. Finally, you must provide a reason why you want Touch ID/Face ID to be used, so you might want to replace mine ("Identify yourself!") with something a little more descriptive.

    You can see the “Identify yourself!” string in our code, which will be shown to Touch ID users. Face ID is handled slightly differently – open Info.plist, then add a new key called “Privacy - Face ID Usage Description”. This should contain similar text to what you use with Touch ID, so give it the value “Identify yourself!”.

    That's enough to get basic biometric authentication working, but there are error cases you need to catch. For example, you’ll hit problems if the device does not have biometric capability or it isn’t configured. Similarly, you’ll get an error if the user failed authentication, which might be because their fingerprint or face wasn't scanning for whatever reason, but also if the system has to cancel scanning for some reason.

    To catch authentication failure errors, replace the **`// error`** comment with this:

    ```swift
    let ac = UIAlertController(title: "Authentication failed", message: "You could not be verified; please try again.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(ac, animated: true)
    ```

    We also need to show an error if biometry just isn't available, so replace the **`// no Touch ID`** comment with this:

    ```swift
    let ac = UIAlertController(title: "Biometry unavailable", message: "Your device is not configured for biometric authentication.", preferredStyle: .alert)
    ac.addAction(UIAlertAction(title: "OK", style: .default))
    self.present(ac, animated: true)
    ```

    That completes the authentication code, so go ahead and try running the app now. If you’re using a physical device your regular Touch ID / Face ID should work just fine, but if you’re using the Simulator there are useful options under the Hardware menu – go to Hardware > Touch ID/Face ID > Toggle Enrolled State to opt in to biometric authentication, then use Hardware > Touch ID/Face ID > Matching Touch/Face when you’re asked for a fingerprint/face.