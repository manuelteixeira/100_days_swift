# Day 58 - Project 15, part two

- Challenges
    1. Go back to project 8 and make the letter group buttons fade out when they are tapped. We were using the **`isHidden`** property, but you'll need to switch to **`alpha`** because **`isHidden`** is either true or false, it has no animatable values between.

        ```swift
        @objc func letterTapped(_ sender: UIButton) {
            guard let buttonTitle = sender.titleLabel?.text else { return }
            
            currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
            
            activatedButtons.append(sender)
            
            UIView.animate(withDuration: 1, animations: {
                sender.alpha = 0.1
            })
        }
        ```

    2. Go back to project 13 and make the image view fade in when a new picture is chosen. To make this work, set the **`alpha`** to 0 first.

        ```swift
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
            
            UIView.animate(withDuration: 1, delay: 0.5, options: [], animations: {
                self.imageView.alpha = 1
            })
        }
        ```

    3. Go back to project 2 and make the flags scale down with a little bounce when pressed.

        ```swift
        @IBAction func buttonTapped(_ sender: UIButton) {
            var title: String
            
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                sender.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            }) { finished in
                UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
                    sender.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
        		// ...
        }
        ```