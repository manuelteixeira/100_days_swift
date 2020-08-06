# Day 98 - Project 30, part two

- **Fixing the bugs: Running out of memory**

    Now, **why does the app crash when you go the detail view controller enough times?** There are **two answers** to this question, **one code related and one not.** 

    For the **second question**, I already explained that **we’re working with supremely over-sized images here** – far larger than we actually need.

    But there's something else subtle here, and it's something we haven't covered yet so this is the perfect time. 

    **When you create a `UIImage` using `UIImage(named:)` iOS loads the image and puts it into an image cache for reuse later**. 

    **This is sometimes helpful**, particularly **if you know the image will be used again**. 

    But **if you know it's unlikely to be reused or if it's quite large, then don't bother putting it into the cache** – it will just add memory pressure to your app and probably flush out other more useful images!

    If you look in the **`viewDidLoad()`** method of **`ImageViewController`** you'll see this line of code:

    ```swift
    let original = UIImage(named: image)!
    ```

    **How likely is it that users will go back and forward to the same image again and again?** **Not likely at all**, **so we can skip the image cache** **by creating our images using the** **`UIImage(contentsOfFile:)`** **initializer** instead. T

    his isn't as friendly as **`UIImage(named:)`** because **you need to specify the exact path to an image** rather than just its filename in your app bundle. The solution is to use **`Bundle.main.path(forResource:ofType:)`**, which is similar to the **`Bundle.main.url(forResource:)`** method we’ve used previously, except it returns a simple string rather than a URL:

    ```swift
    let path = Bundle.main.path(forResource: image, ofType: nil)!
    let original = UIImage(contentsOfFile: path)!
    ```

    Let's take a look at one more problem, this time quite subtle. Loading the images was slow because they were so big, and iOS was caching them unnecessarily. 

    **But `UIImage`'s cache is intelligent: if it senses memory pressure, it automatically clears itself to make room for other stuff.** **So why does our app run out of memory?**

    To find another problems, **profile the app using Instruments and select the allocations instrument again**. This **time filter on "imageviewcontroller" and to begin with** you'll see **nothing because the app starts on the table view. But if you tap into a detail view then go back, you'll see one is created *and remains persistent*** – **it hasn't been destroyed**. Which **means the image it's showing also hasn't been destroyed, hence the massive memory usage.**

    **What's causing the image view controller to never be destroyed?** If you read through **`SelectionViewController.swift`** and **`ImageViewController.swift`** you might spot these two things:

    1. **The selection view controller has a `viewControllers` array that claims to be a cache of the detail view controllers. This cache is never actually used**, and even if it were used it really isn't needed.
    2. The image view controller has a property **`var owner: SelectionViewController!`** – **that makes it a strong reference to the view controller that created it.**

    **The first problem is easily fixed**: **just delete the `viewControllers` array and any code that uses it, because it's just not needed**. 

    The **second problem smells like a strong reference cycle, so you should probably change it to this**:

    ```swift
    weak var owner: SelectionViewController!
    ```

    **Run Instruments again and you'll see that the problem is… still there?! That's right: those two were either red herrings or weren't enough to solve the problem, because something far more sneaky is happening.**

    **The view controllers aren't destroyed because of this line of code in `ImageViewController.swift`:**

    ```swift
    animTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { timer in
    ```

    **That timer does a hacky animation on the image, and it could easily be replaced with better animations as done inside project 15**. But even so, **why does that cause the image view controllers to never leak?**

    **The reason is that when you provide code for your timer to run, the timer holds a strong reference to it so it can definitely be called when the timer is up**. 

    **We're using `self` inside our timer’s code, which means our view controller owns the timer strongly and the timer owns the view controller strongly, so we have a strong reference cycle.**

    **There are several solutions here**: 

    - **rewrite the code using smarter animations, use a `weak self` closure capture list**
    - or **destroy the timer when it's no longer needed, thus breaking the cycle.**

    **We’re going to take the last option here, to give you a little more practice with invalidating timers** – **all we need to do is detect when the image view controller is about to disappear and stop the timer**. We'll do this in **`viewWillDisappear()`**:

    ```swift
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        animTimer.invalidate()
    }
    ```

    **Calling `invalidate()` on a timer stops it immediately, which also forces it to release its strong reference on the view controller it belongs to, thus breaking the strong reference cycle**. 

    **If you profile again, you'll see all the ImageViewController objects are now transient, and the app should no longer be quite so crash-prone.**

    That being said, the app might still crash *sometimes* because despite our best efforts we’re still juggling pictures that are far too big. However, the code is at least a great deal more efficient now, and none of the problems were too hard to find.

- **Challenge**

    1. Go through project 30 and remove all the force unwraps. Note: implicitly unwrapped optionals are not the same thing as force unwraps – you’re welcome to fix the implicitly unwrapped optionals too, but that’s a bonus task.

        ```swift
        // Check code
        ```

    2. Pick any of the previous 29 projects that interests you, and try exploring it using the Allocations instrument. Can you find any objects that are persistent when they should have been destroyed?
    3. For a tougher challenge, take the image generation code out of **`cellForRowAt`**: generate all images when the app first launches, and use those smaller versions instead. For bonus points, combine the **`getDocumentsDirectory()`** method I introduced in project 10 so that you save the resulting cache to make sure it never happens again.

        ```swift
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        	// find the image for this cell, and load its thumbnail
        	let currentImage = items[indexPath.row % items.count]
        	let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
              
              let image = images[imageRootName]
              
        	cell.imageView?.image = image

        	// give the images a nice shadow to make them look a bit more dramatic
              let rendererRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))

        	cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        	cell.imageView?.layer.shadowOpacity = 1
        	cell.imageView?.layer.shadowRadius = 10
        	cell.imageView?.layer.shadowOffset = CGSize.zero
              cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: rendererRect).cgPath

        	// each image stores how often it's been tapped
        	let defaults = UserDefaults.standard
        	cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"

        	return cell
        }
        ```

        ```swift
        func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        		window = UIWindow(frame: UIScreen.main.bounds)
        		
        		let vc = SelectionViewController(style: .plain)
        	      vc.images = convertImages()
        		let nc = UINavigationController(rootViewController: vc)
        		window?.rootViewController = nc
        		window?.makeKeyAndVisible()
        	
        		return true
        }
        ```

        ```swift
        func convertImages() -> [String: UIImage] {
                
            var images = [String: UIImage]()
            
            let fm = FileManager.default
            let path = Bundle.main.resourcePath!
            let items = try! fm.contentsOfDirectory(atPath: path)
                    
            for item in items {
                if item.hasSuffix(".jpg") {
                    
                    let name = item
                    guard let path = Bundle.main.path(forResource: item, ofType: nil) else { return images }
                    guard let original = UIImage(contentsOfFile: path) else { return images }

                    let rendererRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
                    let renderer = UIGraphicsImageRenderer(size: rendererRect.size)

                    let rounded = renderer.image { ctx in
                        ctx.cgContext.addEllipse(in: rendererRect)
                        ctx.cgContext.clip()

                        original.draw(in: rendererRect)
                    }
                    
                    images[name] = rounded
                }
            }
            
            return images
        }
        ```