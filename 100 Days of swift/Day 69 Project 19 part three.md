# Day 69 - Project 19, part three

- Challenge

    1. Add a bar button item that lets users select from a handful of prewritten example scripts, shown using a **`UIAlertController`** – at the very least your list should include the example we used in this project.

        ```swift
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showPossibleScripts))
        ```

        ```swift
        @objc func showPossibleScripts() {
            let ac = UIAlertController(title: "Scripts", message: "Select your script", preferredStyle: .actionSheet)
            
            ac.addAction(UIAlertAction(title: "Alert", style: .default, handler: { [weak self] _ in
                self?.script.text = "alert('Example')"
            }))
            ac.addAction(UIAlertAction(title: "open", style: .default, handler: { [weak self] _ in
                self?.script.text = "window.open('https://www.google.com')"
            }))
            
            present(ac, animated: true)
        }
        ```

    2. You're already receiving the URL of the site the user is on, so use **`UserDefaults`** to save the user's JavaScript for each site. You should convert the URL to a **`URL`** object in order to use its **`host`** property.

        ```swift
        func saveToUserDefaults() {
            let defaults = UserDefaults.standard
            
            if let url = URL(string: pageURL) {
                defaults.set(url, forKey: "URL")
                defaults.set(script.text, forKey: "Script")
            }
            
            print(defaults.url(forKey: "URL"))
            print(defaults.object(forKey: "Script"))
        }
        ```

    3. For something bigger, let users name their scripts, then select one to load using a **`UITableView`**.

        **STILL TO BE DONE** 😞