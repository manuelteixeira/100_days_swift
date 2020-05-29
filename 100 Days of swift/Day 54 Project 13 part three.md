# Day 54 - Project 13, part three

- Challenge
    1. Try making the Save button show an error if there was no image in the image view.

        ```swift
        @IBAction func save(_ sender: Any) {
            guard let image = imageView.image else {
                let ac = UIAlertController(title: "No image selected", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                present(ac, animated: true)
                return
            }
            
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
        ```

    2. Make the Change Filter button change its title to show the name of the currently selected filter.

        ```swift
        filterButton.setTitle(actionTitle, for: .normal)
        ```

    3. Experiment with having more than one slider, to control each of the input keys you care about. For example, you might have one for radius and one for intensity.

        Add the elements to the UI and adjust the constraints.

        ```swift
        @IBAction func radiusChanged(_ sender: UISlider) {
            applyProcessing()
        }
        ```

        ```swift
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(radiusSlider.value * 100, forKey: kCIInputRadiusKey)
        }
        ```