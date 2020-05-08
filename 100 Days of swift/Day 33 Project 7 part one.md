# Day 34 - Project 7, part one

- **Creating the basic UI: UITabBarController**

    **Tab bar -** it lets the user control **which screen they want to view** by tapping on what interests them.

    The **navigation controller adds a gray bar at the top** called a **navigation bar**, and the **tab bar controller adds a gray bar at the bottom** called a **tab bar**.

    **`UITabBarController`** **manages an array of view controllers** that the user can choose between. 

    **`UITabBarItem`** is that **when you set its system item**, **it assigns both an icon and some text for the title of the tab**. **If you try to change the text to your own text, the icon will be removed and you need to provide your own.** 

    This is because Apple has trained users to associate certain icons with certain information, and they don't want you using those icons incorrectly!

    ```swift
    class ViewController: UITableViewController {
        
        var petitions = [String]()

        override func viewDidLoad() {
            super.viewDidLoad()
        }
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return petitions.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            
            cell.textLabel?.text = "Title"
            cell.detailTextLabel?.text = "Subtitle"
            
            return cell
        }

    }
    ```

    **`cellForRowAt`** we’re going to set some dummy **`textLabel.text`** like before, but we’re also going to set **`detailTextLabel.text`** – **that’s the subtitle in our cell.** It’s **called “detail text label” rather than “subtitle” because there are other styles available**, for example one where the detail text is on the right of the main text.

- **Parsing JSON using the Codable protocol**

    **Swift has built-in support for working with JSON using a protocol called `Codable`**. When you say “my data conforms to Codable”, Swift will allow you to convert freely between that data and JSON using only a little code.

    **Swift’s** simple **types** like **`String` and `Int` automatically conform to `Codable`, and arrays and dictionaries also conform to `Codable` if they contain `Codable` objects**.

    Each petition **contains a title, some body text, a signature count, and more**. That means **we need to define a custom struct called `Petition` that stores one petition from our JSON**, which means it will track the title string, body string, and signature count integer.

    ```swift
    struct Petition: Codable {
        var title: String
        var body: String
        var signatureCount: Int
    }
    ```

    **Swift’s Codable protocol needs to know exactly where to find its data, which in this case means making a second struct.**

    ```swift
    struct Petitions: Codable {
        var results: [Petition]
    }
    ```

    Change the array in the **`ViewController`**

    ```swift
    var petitions = [Petition]()
    ```

    **`Data`** like **`String`** and **`Int`** it’s one of Swift’s fundamental data types, although it’s even more low level – **it holds literally any binary data.** It **might be a string**, it **might be the contents of a zip** file, **or literally anything else.**

    **`Data`** and **`String`** have quite a few things in common. You already saw that **`String` can be created using** `contentsOf` **to load data from disk, and `Data` has exactly the same initializer.**

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        let urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                // we're OK to parse!
    						parse(json: data)
            }
        }
    }
    ```

    - **`urlString`** points either to the Whitehouse.gov server or to my cached copy of the same data, accessing the available petitions.
    - **We use `if let` to make sure the `URL` is valid,** rather than force unwrapping it. Later on you can return to this to add more URLs, so it's good play it safe.
    - We create a new **`Data`** object using its **`contentsOf`** method. **This returns the content from a `URL`,** but **it might throw an error** (i.e., if the internet connection was down) so we need to use **`try?`**.
    - This code isn't perfect, in fact far from it. In fact, **by downloading data from the internet in viewDidLoad() our app will lock up until all the data has been transferred.** There are solutions to this, but to avoid complexity they won't be covered until project 9.

    ```swift
    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.reloadData()
        }
    }
    ```

    1. It creates an **instance** of **`JSONDecoder`**, which is **dedicated to converting between JSON and `Codable` objects.**
    2. It then calls the **`decode()`** method on that decoder, **asking it to convert our `json` data into a `Petitions` object.** This is a throwing call, so we use **`try?`** to check whether it worked.
    3. If the JSON was converted successfully, assign the **`results`** array to our **`petitions`** property then reload the table view.

    **`Petitions.self`**, which is **Swift’s way of referring to the `Petitions` type itself rather than an instance of it. Specifying it as a parameter to the decoding so `JSONDecoder` knows what to convert the JSON too.**

    ```swift
    let petition = petitions[indexPath.row]
    cell.textLabel?.text = petition.title
    cell.detailTextLabel?.text = petition.body
    ```