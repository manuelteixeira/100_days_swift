# Day 52 - Project 13, part one

- **Designing the interface**

    ![Day%2052%20Project%2013%20part%20one%200abaca632c174566b648821ab6584854/Screenshot_2020-05-27_at_08.11.07.jpg](Day%2052%20Project%2013%20part%20one%200abaca632c174566b648821ab6584854/Screenshot_2020-05-27_at_08.11.07.jpg)

    **Using Xcode to make your Auto Layout rules can be a real help, but it won't be right all the time**. After all, **it just takes its best guess as to your intentions**. It will **also frequently add more constraints than strictly necessary for the job, so use it with care.**

    Add an **outlet for the image view and the slider**, called respectively **`imageView`** and **`intensity`**. Please also **create actions from the two buttons**, calling methods **`changeFilter()`** and **`save()`**. You can leave these methods with no code inside them for now.

    Finally, **we want the user interface to update when the slider is dragged**. It **should give you the "Value Changed"** event rather than Touch Up Inside, and that's what we want. **Call the action's method `intensityChanged().`**

    ```swift
    class ViewController: UIViewController {
        @IBOutlet weak var imageView: UIImageView!
        @IBOutlet weak var intensitySlider: UISlider!

        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }

        @IBAction func changeFilter(_ sender: Any) {
        }
        
        @IBAction func save(_ sender: Any) {
        }
        
        @IBAction func intensityChanged(_ sender: Any) {
        }
    }
    ```

- **Importing a picture**