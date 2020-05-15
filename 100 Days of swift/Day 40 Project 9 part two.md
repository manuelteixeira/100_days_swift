# Day 40 - Project 9, part two

- **Challenges**
    1. Modify project 1 so that loading the list of NSSL images from our bundle happens in the background. Make sure you call **`reloadData()`** on the table view once loading has finished!

        ```swift
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = "Storm Viewer"
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAppTapped))
            
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                let fm = FileManager.default
                let path = Bundle.main.resourcePath!
                let items = try! fm.contentsOfDirectory(atPath: path)
                
                for item in items {
                    if item.hasPrefix("nssl") {
                        self?.pictures.append(item)
                    }
                }
                self?.pictures.sort()
                
                DispatchQueue.main.async { [weak self] in
                    self?.tableView.reloadData()
                }
                
                print(self?.pictures)
            }
            
        }
        ```

    2. Modify project 8 so that loading and parsing a level takes place in the background. Once you’re done, make sure you update the UI on the main thread!

        ```swift
        override func viewDidLoad() {
            super.viewDidLoad()
            
            performSelector(inBackground: #selector(loadLevel), with: nil)
        }
        ```

        ```swift
        @objc func loadLevel() {
            var clueString = ""
            var solutionString = ""
            var letterBits = [String]()
            
            if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
                if let levelContents = try? String(contentsOf: levelFileURL) {
                  var lines = levelContents.components(separatedBy: "\n")
                    lines.shuffle()
                    
                    for (index, line) in lines.enumerated() {
                        let parts = line.components(separatedBy: ": ")
                        let answer = parts[0]
                        let clue = parts[1]
                        
                        clueString += "\(index + 1). \(clue)\n"
                        
                        let solutionWord = answer.replacingOccurrences(of: "|", with: "")
                        solutionString += "\(solutionWord.count) letters\n"
                        solutions.append(solutionWord)
                        
                        let bits = answer.components(separatedBy: "|")
                        letterBits += bits
                    }
                }
            }
                
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                
                self.cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
                self.answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
                
                self.letterButtons.shuffle()
                
                if self.letterButtons.count == letterBits.count {
                    for i in 0..<self.letterButtons.count {
                        self.letterButtons[i].setTitle(letterBits[i], for: .normal)
                    }
                }
            }
            
        }
        ```

    3. Modify project 7 so that your filtering code takes place in the background. This filtering code was added in one of the challenges for the project, so hopefully you didn’t skip it!

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
                
                self.performSelector(inBackground: #selector(self.filterPetitions), with: text)
            }
            
            alertController.addAction(action)
            
            present(alertController, animated: true)
        }
        ```

        ```swift
        @objc func filterPetitions(_ text: String) {
                
            filteredPetitions = petitions.filter({ petition -> Bool in
                return petition.title.contains(text)
            })
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
        ```