# Day 34 - Project 7, part two

- **Rendering a petition: loadHTMLString**

    ```swift
    class DetailViewController: UIViewController {
        
        var webView: WKWebView!
        var detailItem: Petition?
        
        override func loadView() {
            webView = WKWebView()
            view = webView
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            
            guard let detailItem = detailItem else { return }
            
            let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1" />
            <style> body { font-size: 150% } </style>
            </head>
            <body>
            \(detailItem.body)
            </body>
            </html>
            """
            
            webView.loadHTMLString(html, baseURL: nil)
        }

    }
    ```

    That **`guard`** **unwraps `detailItem` into itself if it has a value, which makes sure we exit the method if for some reason we didn’t get any data passed** into the detail view controller.

    We still need to **connect it to the table view controller by implementing the `didSelectRowAt` method.**

    Previously **we used the `instantiateViewController()` method to load a view controller from Main.storyboard**, **but in this project `DetailViewController` isn’t in the storyboard** – it’s just a free-floating class. 

    This makes **`didSelectRowAt`** easier, because **it can load the class directly rather than loading the user interface from a storyboard.**

    ```swift
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    ```

- **Finishing touches: didFinishLauchingWithOptions**

    We're going to **add another tab** to the **`UITabBarController`** that **will show popular petitions.**

    **We can't really put the second tab into our storyboard because both tabs will host a `ViewController`** and **doing so would require us to duplicate the view controllers in the storyboard**. It's a maintenance nightmare!

    **`didFinishLaunchingWithOptions`** this **gets called** by iOS **when the app has finished loading and is ready to be used.**

    Since iOS 13 we need to use the **SceneDelegate** and in the **scene() put this:**

    ```swift
    if let tabBarController = window?.rootViewController as? UITabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NavController")
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .topRated, tag: 1)
        tabBarController.viewControllers?.append(vc)
    }
    ```

    - **Our storyboard automatically creates a window in which all our view controllers are shown.** **This window needs to know what its initial view controller** is, **and that gets set to** its **`rootViewController`** **property**. This is all handled by our storyboard.
    - In the Single View App template, the root view controller is the **`ViewController`**, but **we embedded ours inside a navigation controller, then embedded *that* inside a tab bar controller.** So, for us the **root view controller is a** **`UITabBarController`**.
    - **We need to create a new `ViewController` by hand, which first means getting a reference to our Main.storyboard file.** This is done using the **`UIStoryboard`** class, as shown. You don't need to provide a bundle, because **`nil`** means "use my current app bundle."
    - We create our view controller using the **`instantiateViewController()`** method, passing in the storyboard ID of the view controller we want. Earlier we set our navigation controller to have the storyboard ID of "NavController", so we pass that in.
    - **We create** a **`UITabBarItem`** object f**or the new view controller**, giving it the "Top Rated" icon and the tag 1.
    - **We add the new view controller to our tab bar controller's** **`viewControllers`** array, which will cause it to appear in the tab bar.

    **This lets us use the same class for both tabs without having to duplicate things in the storyboard.**

    **The reason we gave a tag of 1** to the new **`UITabBarItem`** **is because it's an easy way to identify it.** Remember, **both tabs contain a ViewController**, **which means the same code is executed**. Right now that means both will download the same JSON feed, which makes having two tabs pointless.

    ```swift
    let urlString: String

    if navigationController?.tabBarItem.tag == 0 {
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
    } else {
        urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
    }
    ```

    **That adjusts the code so that the first instance of ViewController loads the original JSON**, and **the second loads only petitions that have at least 10,000 signatures.**

    We have a couple of if statements checking that things are working correctly, but **no else statements showing an error message if there's a problem.**

    ```swift
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    ```

    ```swift
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            parse(json: data)
        } else {
            showError()
        }
    } else {
        showError()
    }
    ```

    or

    ```swift
    if let url = URL(string: urlString) {
        if let data = try? Data(contentsOf: url) {
            parse(json: data)
            return
        }
    }

    showError()
    ```