# Day 39 - Project 9, part one

- **Why is locking the UI bad?**

    We used `**Data**`'s **`contentsOf` to download data from the internet, which is what's known as a blocking call.** That is, **it blocks execution of any further code in the method until it has connected to the server and fully downloaded all the data.**

    Each CPU can be doing something independently of the others, which hugely boosts your performance. **These code execution processes are called threads**, and come with a number of important provisos:

    1. **Threads execute the code you give them**, they don't just randomly execute a few lines from **`viewDidLoad()`** each. This means **by default your own code executes on only one CPU**, **because you haven't created threads for other CPUs to work on.**
    2. **All user interface work must occur on the main thread,** which is the initial thread your program is created on. If you try to execute code on a different thread, it might work, it might fail to work, it might cause unexpected results, or it might just crash.
    3. **You don't get to control when threads execute**, **or in what order.** You create them and give them to the system to run, and the system handles executing them as best it can.
    4. Because you don't control the execution order, **you need to be extra vigilant in your code to ensure only one thread modifies your data at one time.**

    Broadly speaking, **if you’re accessing any remote resource, you should be doing it on a background thread.**

    **If you're executing any slow code, you should be doing it on a background thread.** 

    **If you're executing any code that can be run in parallel** – e.g. adding a filter to 100 photos – **you should be doing it on multiple background threads.**

    ```swift

    ```

- **GCD 101: async()**

    **We're going to use `async()` twice**: 

    once to **push some code to a background thread**, 

    then **once more to push code back to the main thread.** 

    This **allows us to do any heavy lifting away from the user interface where we don't block things**, but **then update the user interface safely on the main thread** – which is the only place it can be safely updated.

    **How you call `async()` informs the system where you want the code to run.** 

    **GCD works with a system of queues**: 

    - they are First In, First Out (**FIFO**) blocks of code.
    - What this means is that your **GCD calls don't create threads to run in**, **they just get assigned to one of the existing threads for GCD to manage.**

    **GCD creates for you a number of queues**, and **places tasks in those queues depending on how important you say they are**. 

    **“How important” some code is depends on something called “quality of service”, or QoS**, which **decides what level of service this code should be given.** 

    **main queue**, which runs on your main thread, and **should be used to schedule any work that must update the user interface immediately** even when that means blocking your program from doing anything else. But **there are four background queues:**

    1. **User Interactive**: this is the **highest priority background thread**, and should be **used when you want a background thread to do work that is important to keep your user interface working**. This priority will **ask the system to dedicate nearly all available CPU time** to you to get the job done as quickly as possible.
    2. **User Initiated**: this should be **used to execute tasks requested by the user** that they are now waiting for in order to continue using your app. It's not as important as user interactive work – i.e., **if the user taps on buttons to do other stuff, that should be executed first – but it is important because you're keeping the user waiting.**
    3. **Utility**: this should be **used for long-running tasks that the user is aware of, but not necessarily desperate for now**. If the user has requested something and can happily leave it running while they do something else with your app, you should use Utility.
    4. **Background**: this is for **long-running tasks that the user isn't actively aware of**, or at least **doesn't care about its progress or when it completes.**

    **User Interactive** **and User Initiated tasks will be executed as quickly as possible regardless of their effect on battery life.** 

    **Utility tasks will be executed with a view to keeping power efficiency as high as possible without sacrificing too much performance.**

    **Background tasks will be executed with power efficiency as its priority**.

    There’s also one more option, which is the **default queue**. **This is prioritized between user-initiated and utility.**

    **`async()`** to **make** all **our** loading **code** **run** **in the background queue with default quality of service.**

    ```swift
    DispatchQueue.global().async { ... }
    ```

    If you wanted to **specify the user-initiated quality of service rather than use the default queue.**

    Because **`async()` uses closures**, **you might think to start with `[weak self] in`** to **make sure there aren’t any accident strong reference cycles**, but **it isn’t necessary here because GCD runs the code once then throws it awa**y – it won’t retain things used inside.

    ```swift
    DispatchQueue.global(qos: .userInitiated).async {
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                self.parse(json: data)
                return
            }
        }
    }

    showError()
    ```

- **Back to the main thread: DispatchQueue.main**

    **Pushing work to the background thread**, and **any further code called in that work will also be on the background thread.**

    **It's OK to parse the JSON on a background thread, but it's never OK to do user interface work there.**

    **If you're on a background thread and want to execute code on the main thread**, you need to call **`async()`** on **`DispatchQueue.main`.**

    **We could modify our code to have `async()` before every call to `showError()` and `parse()`**, but **that's both ugly and inefficient.** 

    It's **better to place the `async()` call inside `showError()` and** also **inside** **`parse()`**, but **only where the table view is being reloaded**. **The actual JSON parsing can happily stay on the background thread.**

    ```swift
    DispatchQueue.main.async { [weak self] in
        self?.tableView.reloadData()
    }
    ```

    ```swift
    DispatchQueue.global(qos: .userInitiated).async { [weak self] in
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                self?.parse(json: data)
                return
            }
        }
        
        self?.showError()
    }
    ```

    ```swift
    func showError() {
        DispatchQueue.main.async { [weak self] in
            let alertController = UIAlertController(title: "Loading error", message: "There was a problem", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(action)
            
            self?.present(alertController, animated: true)
        }

    }
    ```

- **Easy GCD using performSelector(inBackground:)**

    There’s **another way of using GCD.** It’s called **`performSelector()`**, and it **has two interesting variants**: 

    **`performSelector(inBackground:)`**

    **`performSelector(onMainThread:)`**

    **you pass it the name of a method to run**, and **`inBackground`** will **run it on a background thread**, and **`onMainThread`** **will run it on a foreground thread.** 

    If you intend to run a whole method on either a background thread or the main thread, these two are easiest.

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(fetchJSON), with: nil)
    }

    @objc func fetchJSON() {
        let urlString: String

        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        } else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }

        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()

        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        }
    }

    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    ```

    As you can see, **it makes your code easier because you don’t need to worry about closure capturing.**

    ```swift
    if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
        petitions = jsonPetitions.results
        tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
    } else {
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    ```

    This refactored code also makes the return call inside **`fetchJSON()`** **work as intended: the `showError()` method is never called when things go well, because the whole method is exited.**