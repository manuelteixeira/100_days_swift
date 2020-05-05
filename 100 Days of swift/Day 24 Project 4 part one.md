# Day 24 - Project 4, part one

- **Creating a simple browser with WKWebView**

    iOS has two different ways of working with web views, but the one we’ll be using for this project is called **WKWebView**. **It’s part of the WebKit framework** rather than the UIKit framework, but we can import it.

    ```swift
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
    }
    ```

    **Note**: You don’t need to put **`loadView()`** before **`viewDidLoad()`.** Structure your methods in an organized way, and because loadView() gets called before viewDidLoad() it makes sense to position the code above it too.

    A ***delegate*** **is one thing acting in place of another**, effectively **answering questions and responding to events on its behalf**. 

    In our example, we're using WKWebView: Apple's powerful, flexible and efficient web renderer. But as smart as **`WKWebView`** is, it doesn't know (or care) how our application wants to behave, because that's our custom code.

    The delegation solution is brilliant: **we can tell `WKWebView` that we want to be informed when something interesting happens.** 

    In our code, we're setting the web view's **`navigationDelegate`** property to **`self`**, **which means "when any web page navigation happens, please tell me – the current view controller.”**

    When you do this, two things happen:

    1. You **must conform to the protocol**. This is a fancy way of saying, "if you're telling me you can handle being my delegate, here are the methods you need to implement." In the case of **`navigationDelegate`**, all these methods are optional, meaning that we don't *need* to implement any methods.
    2. **Any methods you do implement will now be given control over the `WKWebView`'s behavior. Any you don't implement will use the default behavior of `WKWebView`.**

    ```swift
    class ViewController: UIViewController, WKNavigationDelegate { ... }
    ```

    The **parent class** (superclass) **comes first**, **then all protocols implemented come next**, all separated by commas.

    "create a new subclass of UIViewController called ViewController, and tell the compiler that we promise we’re safe to use as a WKNavigationDelegate."

    ```swift
    let url = URL(string: "https://www.hackingwithswift.com")!
    webView.load(URLRequest(url: url))
    webView.allowsBackForwardNavigationGestures = true
    ```

- **Choosing a website: UIAlertController action sheets**

    ```swift
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page…", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    ```

    Setting the alert controller’s **`popoverPresentationController?.barButtonItem`** property is used only on **iPad**, and **tells iOS where it should make the action sheet be anchored.**

    We used the **`UIAlertController`** class in project 2, but here it's slightly different for three reason:

    1. We're using **`nil`** for the message, **because this alert doesn't need one.**
    2. We're using the **`preferredStyle`** of **`.actionSheet`** because we're **prompting the user for more information.**
    3. We're adding a dedicated Cancel button using style **`.cancel`**. **It doesn’t provide a `handler` parameter, which means iOS will just dismiss the alert controller if it’s tapped.**

    ```swift
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    ```

    This method takes one parameter, which is the **`UIAlertAction`** **object that was selected by the user.** 

    ```swift
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    ```

    All this method does is **update our view controller's title property to be the title of the web view**, which **will automatically be set to the page title of the web page that was most recently loaded.**

## Summary

---

-