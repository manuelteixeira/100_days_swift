# Day 53 - Project 13, part two

- **Applying filters: CIContext, CIFilter**

    ```swift
    import CoreImage
    ```

    ```swift
    var context: CIContext!
    var currentFilter: CIFilter!
    ```

    The first is a **Core Image context**, which is the **Core Image component that handles rendering.** We create it here and use it throughout our app, **because creating a context is computationally expensive so we don't want to keep doing it.**

    The second is a **Core Image filter**, and **will store whatever filter the user has activated**. This filter will be given various input settings before we ask it to output a result for us to show in the image view.

    We want to create both of these in **`viewDidLoad()`**

    ```swift
    context = CIContext()
    currentFilter = CIFilter(name: "CISepiaTone")
    ```

    That creates a default Core Image context, then creates an example filter that will apply a sepia tone effect to images.

    We need to **set our `currentImage`** property **as the input image for the `currentFilter` Core Image filter**. 

    So, add this to the end of the **`didFinishPickingMediaWithInfo`** method:

    ```swift
    let beginImage = CIImage(image: currentImage)
    currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

    applyProcessing()
    ```

    The **`CIImage`** data type is the **Core Image equivalent of `UIImage`**.

    **We can create a `CIImage` from a `UIImage`**, and **we send the result into the current Core Image Filter using the `kCIInputImageKey`**. 

    We also need to call the **`applyProcessing()`** method **when the slider is dragged around**, so modify the **`intensityChanged()`** method to this:

    ```swift
    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    ```

    ```swift
    func applyProcessing() {
        guard let image = currentFilter.outputImage else { return }
        
    		currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)

        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            imageView.image = processedImage
        }
    }
    ```

    The second line **uses the value of our intensity slider to set the `kCIInputIntensityKey` value of our current Core Image filter**. For sepia toning a value of 0 means "no effect" and 1 means "fully sepia."

    The third line, **creates a new data type called `CGImage` from the output image of the current filter**. **We need to specify which part of the image we want to render**, but **using `image.extent` means "all of it."** Until this method is called, no actual processing is done, so this is the one that does the real work. T**his returns an optional `CGImage` so we need to check and unwrap with `if let`.**

    The fourth line **creates a new `UIImage` from the `CGImage`**, and line five **assigns that `UIImage` to our image view**.

    ```swift
    @IBAction func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    ```

    When tapped, each of the filter buttons will call the **`setFilter()`** method, which we need to make. **This method should update our `currentFilter` property with the filter that was chosen, set the `kCIInputImageKey` key again, then call `applyProcessing()`.**

    ```swift
    func setFilter(action: UIAlertAction) {  
        // make sure we have a valid image before continuing!
        guard currentImage != nil else { return }

        // safely read the alert action's title
        guard let actionTitle = action.title else { return }

        currentFilter = CIFilter(name: actionTitle)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }
    ```

    Our current code has a problem, and it's this line:

    ```swift
    currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
    ```

    That sets the intensity of the current filter. But the **problem is that not all filters have an intensity setting**. **If you try this using the `CIBumpDistortion` filter, the app will crash because it doesn't know what to do with a setting for the key `kCIInputIntensityKey`.**

    ```swift
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }

        if let cgimg = context.createCGImage(currentFilter.outputImage!, from: currentFilter.outputImage!.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    ```

- **Saving to the iOS photo library**

    **`UIImageWriteToSavedPhotosAlbum()`**. This method does exactly what its name says: **give it a `UIImage` and it will write the image to the photo album.**

    This method **takes four parameters**: the **image to write**, **who to tell when writing has finished**, **what method to call**, **and any context**. 

    The context is just like the context value you can use with KVO, as seen in project 4, and again we're not going to use it here. 

    The first two parameters are quite simple: **we know what image we want to save** (the processed one in the image view), **and we also know that we want `self`** (the current view controller) **to be notified when writing has finished.**

    The **third parameter** **needs to be a selector that lists the method in our view controller that will be called**, and it's specified using **`#selector`**. The method it will call will look like this:

    ```swift
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
    }
    ```

    Previously we've had very simple selectors, like **`#selector(shareTapped)`**. And **we can use that approach here** – Swift allows us to be really vague about the selector we intend to call, and this works just fine:

    ```swift
    #selector(image)
    ```

    Yes, **that approach is nice and easy to read, but it's also very vague**: **it doesn't say what is actually going to happen**. The **alternative is to be very specific** about the method we want called, so you can write this:

    ```swift
    #selector(image(_:didFinishSavingWithError:contextInfo:))
    ```

    This second option is longer, but **provides much more information both to Xcode and to other people reading your code**, so it's generally preferred.

    ```swift
    @IBAction func save(_ sender: Any) {
        guard let image = imageView.image else { return }

        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    ```

    From here on it's easy, because we just need to write the **`didFinishSavingWithError`** method. **This must show one of two messages depending on whether we get an error sent to us**. The error might be, for example, that the user denied us permission to write to the photo album. This will be sent as an Error? object, so if it's nil we know there was no error.

    This parameter is important because **if an error has occurred** (i.e., the error parameter is not nil) **then we need to unwrap the Error object and use its `localizedDescription` property** – this will tell users what the error message was in their own language.

    ```swift
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    ```