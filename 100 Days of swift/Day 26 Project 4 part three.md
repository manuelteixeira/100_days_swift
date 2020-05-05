# Day 26 - Project 4, part three

- **Challenge**
    1. If users try to visit a URL that isn’t allowed, show an alert saying it’s blocked.

        ```swift
        func showNotAllowedURLAlert() {
            let title = "Not allowed"
            let message = "Sorry, but that isn't an allowed URL"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(action)
            
            present(alertController, animated: true)
        }
        ```

        ```swift
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let url = navigationAction.request.url
            
            guard let host = url?.host else {
                decisionHandler(.cancel)
                return
            }
            
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            
            showNotAllowedURLAlert()
            
            decisionHandler(.cancel)
        }
        ```

    2. Try making two new toolbar items with the titles Back and Forward. You should make them use **`webView.goBack`** and **`webView.goForward`**.

        ```swift
        let back = UIBarButtonItem(title: "Back", style: .plain, target: webView, action: #selector(webView.goBack))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: webView, action: #selector(webView.goForward))
                
        toolbarItems = [back, progressButton, spacer, refresh, forward]
        ```

    3. For more of a challenge, try changing the initial view controller to a table view like in project 1, where users can choose their website from a list rather than just having the first in the array loaded up front.