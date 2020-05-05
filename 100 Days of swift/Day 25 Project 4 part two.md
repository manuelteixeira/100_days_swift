# Day 25 - Project 4, part two

- **Monitoring page loads: UIToolbar and UIProgressView**
    - **`UIToolbar`**

        **`UIToolbar`** **holds and shows a collection of `UIBarButtonItem` objects that the user can tap on.** We already saw how each view controller has a **`rightBarButton`** item, so a `**UIToolbar**` is like having a whole bar of these items.

    - **`UIProgressView`**

        is a **colored bar that shows how far a task is through its work**, sometimes called a "progress bar."

    **All view controllers automatically come with a `toolbarItems` array** that automatically gets read in when the view controller is active inside a **`UINavigationController`**.

    All **we need to do** is **set the array, then tell our navigation controller to show its toolbar**, and it will do the rest of the work for us.

    We're going to create two **`UIBarButtonItems`** at first, although one is special because it's a **flexible space**. This is a unique **`UIBarButtonItem`** type that **acts like a spring, pushing other buttons to one side until all the space is used**.

    It **doesn't** **need** a **`target`** or **`action`** **because it can't be tapped.**

    ```swift
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))

    toolbarItems = [spacer, refresh]
    navigationController?.isToolbarHidden = false
    ```

    The first line **creates an array containing the flexible space and the refresh button**, then **sets it** **to be our view controller's toolbarItems** array. 

    The second line **sets the navigation controller's `isToolbarHidden` property to be false**, **so the toolbar will be shown** – and its items will be loaded from our current view.

    The next step is going to be to add a **`UIProgressView`** to our toolbar, which will show how far the page is through loading. However, this requires two new pieces of information:

    - **You can't just add random** **`UIView`** **subclasses** to a **`UIToolbar`**, or to the **`rightBarButtonItem`** property. Instead, **you need to wrap them in a special `UIBarButtonItem`, and use that instead.**

        ```swift
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        ```

    - Although **`WKWebView`** tells us how much of the page has loaded using its **`estimatedProgress`** property, the **`WKNavigationDelegate`** **system doesn't tell us when this value has changed.** So, **we're going** to ask iOS to tell us using a powerful technique called **key-value observing**, or **KVO**.

        key-value observing (KVO), and it **effectively lets you say, "please tell me when the property X of object Y gets changed by anyone at any time."**

        ```swift
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        ```

        The **`addObserver()`** method takes four parameters: 

        **who the observer is** (we're the observer, so we use **`self`**), **what property we want to observe** (we want the **`estimatedProgress`** property of **`WKWebView`**), 

        **which value we want** (we want the value that was just set, so we want the new one), 

        **and a context value.**

        **`forKeyPath`** it's not just about entering a property name. **You can actually specify a path**: **one property inside another, inside another, and so on.** More advanced key paths can even add functionality, such as averaging all elements in an array!

        **`context`** if you provide a unique value, **that same context value gets sent back to you when you get your notification that the value has changed.** This allows you to check the context to make sure it was your observer that was called.

        **Warning**: in more complex applications, all calls to **`addObserver()`** should be matched with a call to **`removeObserver()`** when you're finished observing – for example, when you're done with the view controller.

        Once you have registered as an observer using KVO, **you must implement a method called `observeValue()`.** **This tells you when an observed value has changed.**

        ```swift
        override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress" {
                progressView.progress = Float(webView.estimatedProgress)
            }
        }
        ```

- **Refactoring for the win**

    The flaw is this: **we let users select from a list of websites, but once they are on that website they can get pretty much anywhere else they want just by following links.** Wouldn't it be nice if we could check every link that was followed so that we can make sure it's on our safe list?

    ```swift
    var websites = ["apple.com", "hackingwithswift.com"]
    ```

    ```swift
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let url = navigationAction.request.url

        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
        }

        decisionHandler(.cancel)
    }
    ```

    We use the **`contains()`** String method **to see whether each safe website exists somewhere in the host name.** (For example, [slashdot.org](http://slashdot.org/) redirects to [m.slashdot.org](http://m.slashdot.org/))

    The method  **`decidePolicyFor`** (**`WKWebView`**) This delegate callback **allows us to decide whether we want to allow navigation to happen or not every time something happens.**

    Now that we've implemented this method, it expects a response: should we load the page or should we not? When this method is called, you get passed in a parameter called **`decisionHandler`**. This actually holds a function, which means if you "call" the parameter, you're actually calling the function.

    Having this **`decisionHandler`** variable/function **means you can show some user interface to the user "Do you really want to load this page?" and call the closure when you have an answer.**

    Because **you might call the `decisionHandler` closure straight away, or you might call it later on** (perhaps after asking the user what they want to do), **Swift considers it to be an escaping closure.** That is, the closure has the potential to escape the current method, and be used at a later date. **Swift wants us to add the special keyword `@escaping` when specifying this method.**