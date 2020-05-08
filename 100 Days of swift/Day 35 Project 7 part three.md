# Day 35 - Project 7, part three

- **Challenges**
    1. Add a Credits button to the top-right corner using **`UIBarButtonItem`**. When this is tapped, show an alert telling users the data comes from the We The People API of the Whitehouse.

        ```swift
        let creditsButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
                
        navigationItem.rightBarButtonItem = creditsButtonItem
        ```

        Update the parse method

        ```swift
        func parse(json: Data) {
            let decoder = JSONDecoder()
            
            if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
                petitions = jsonPetitions.results
                filteredPetitions = petitions
                tableView.reloadData()
            }
        }
        ```

        ```swift
        @objc func showCredits() {
            let alertController = UIAlertController(title: "Credits", message: "This data came from the We The People API of the whitehouse", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(action)
            
            present(alertController, animated: true)
        }
        ```

    2. Let users filter the petitions they see. This involves creating a second array of filtered items that contains only petitions matching a string the user entered. Use a **`UIAlertController`** with a text field to let them enter that string. This is a tough one, so I’ve included some hints below if you get stuck.

        Add a filter and clear button to navbar.

        ```swift
        let filterButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilter))
        let clearButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearFilteredPetitions))
                
        navigationItem.leftBarButtonItems = [clearButtonItem, filterButtonItem]
        ```

        Show the alert controller for the user to insert the filter string

        ```swift
        @objc func showFilter() {
            let alertController = UIAlertController(title: "Filter petitions", message: nil, preferredStyle: .alert)
            
            alertController.addTextField()
            
            let action = UIAlertAction(title: "Filter", style: .default) { [weak self, weak alertController] _ in
                
                guard let self = self,
                    let text = alertController?.textFields?[0].text
                else {
                    return
                }
                
                self.filterPetitions(text)
            }
            
            alertController.addAction(action)
            
            present(alertController, animated: true)
        }
        ```

        Filter the petitions

        ```swift
        func filterPetitions(_ text: String) {
                
            filteredPetitions = petitions.filter({ petition -> Bool in
                return petition.title.contains(text)
            })
            
            tableView.reloadData()
        }
        ```

        Method for clear the filtered petitions

        ```swift
        @objc func clearFilteredPetitions() {
            filteredPetitions.removeAll()
            filteredPetitions.append(contentsOf: petitions)
            
            tableView.reloadData()
        }
        ```

    3. Experiment with the HTML – this isn’t a HTML or CSS tutorial, but you can find lots of resources online to give you enough knowledge to tinker with the layout a little.

        ```swift
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <style> body { font-size: 150% } h1 { color: green; font-size: 180% } </style>
        </head>
        <body>
        <h1>\(detailItem.title)</h1>
        \(detailItem.body)
        </body>
        </html>
        """
        ```