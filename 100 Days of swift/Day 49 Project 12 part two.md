# Day 49 - Project 12, part two

- **Fixing Project 10: Codable**

    **`NSCoding`** is a great way to read and write data when using **`UserDefaults`**, and **is the most common option when you must write Swift code that lives alongside Objective-C code.**

    However, if you’re **only writing Swift**, the **`Codable`** **protocol** **is much easier**. 

    There are three primary **differences** between the two solutions:

    1. The **`Codable`** system **works on both classes and structs**. We made **`Person`** a class because **`NSCoding`** only works with classes, but if you didn’t care about Objective-C compatibility you could make it a struct and use **`Codable`** instead.
    2. When we implemented **`NSCoding`** in the previous chapter we had to write **`encode()`** and **`init()`** calls ourself. **With `Codable` this isn’t needed unless you need more precise control** - it does the work for you.
    3. When you encode data using **`Codable`** you can save to the same format that **`NSCoding`** uses if you want, but a much more pleasant option is JSON – **`Codable`** **reads and writes JSON natively.**

    ```swift
    class Person: NSObject, Codable { ... }
    ```

    Just adding **`Codable`** to the class definition i**s enough to tell Swift we want to read and write this thing**.

    This time it’s going to use the **`JSONEncoder`** class **to convert our people array into a Data objec**t, which can **then be saved to `UserDefaults`**. 

    This conversion might fail, so **we’re going to use `if let` and `try?` so that we save data only when the JSON conversion was successful.**

    ```swift
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    ```

    ```swift
    let defaults = UserDefaults.standard

    if let savedPeople = defaults.object(forKey: "people") as? Data {
        let jsonDecoder = JSONDecoder()

        do {
            people = try jsonDecoder.decode([Person].self, from: savedPeople)
        } catch {
            print("Failed to load people")
        }
    }
    ```

    We use the **`object(forKey:)`** method to **pull out an optional `Data`**, **using `if let` and `as?` to unwrap it.** 

    We then give that to an instance of **`JSONDecoder`** **to convert it back to an object graph** – i.e., our array of Person objects.

- **Challenges**
    1. Modify project 1 so that it remembers how many times each storm image was shown – you don’t need to show it anywhere, but you’re welcome to try modifying your original copy of project 1 to show the view count as a subtitle below each image name in the table view.

        ```swift
        struct Picture: Codable, Comparable {
            let name: String
            var shownCount: Int
            
            static func < (lhs: Picture, rhs: Picture) -> Bool {
                lhs.name < rhs.name
            }
        }
        ```

        ```swift
        func save() {
            let jsonEnconder = JSONEncoder()
            
            if let savedData = try? jsonEnconder.encode(pictures) {
                let defaults = UserDefaults.standard
                defaults.set(savedData, forKey: "pictures")
            }
        }

        func load() {
            let defaults = UserDefaults.standard
            
            if let picturesData = defaults.object(forKey: "pictures") as? Data {
                let jsonDecoder = JSONDecoder()
                
                do {
                    pictures = try jsonDecoder.decode([Picture].self, from: picturesData)
                } catch {
                    print("Failed to load.")
                }
            }
        }
        ```

        ```swift
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
            
            cell.textLabel?.text = pictures[indexPath.row].name
            cell.detailTextLabel?.text = "\(pictures[indexPath.row].shownCount)"
            return cell
        }
        ```

    2. Modify project 2 so that it saves the player’s highest score, and shows a special message if their new score beat the previous high score.

        ```swift
        func checkHighScore() {
              let defaults = UserDefaults.standard
              let previousScore = defaults.integer(forKey: "score")
              
              if score > previousScore {
                  save()
                  showHighScoreAlert()
              }
          }
            
          func save() {
              let defaults = UserDefaults.standard
              
              defaults.set(score, forKey: "score")
          }
          
          func showHighScoreAlert() {
              let alertController = UIAlertController(title: "NEW HIGH SCORE", message: nil, preferredStyle: .alert)
              alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
              
              present(alertController, animated: true)
          }
        ```

    3. Modify project 5 so that it saves the current word and all the player’s entries to **`UserDefaults`**, then loads them back when the app launches.

        ```swift
        @objc func startGame() {  
            let defaults = UserDefaults.standard
            
            usedWords = defaults.stringArray(forKey: "usedWords") ?? [String]()
            title = defaults.string(forKey: "currentWord") ?? allWords.randomElement()
            
            tableView.reloadData()
        }

        @objc func resetGame() {
            title = allWords.randomElement()
            usedWords.removeAll(keepingCapacity: true)
            save()
            tableView.reloadData()
        }

        func save() {
            let defaults = UserDefaults.standard
            
            defaults.set(usedWords, forKey: "usedWords")
            defaults.set(title, forKey: "currentWord")
        }
        ```