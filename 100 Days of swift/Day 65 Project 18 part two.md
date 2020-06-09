# Day 65 - Project 18, part two

- **Challenge**

    1. Temporarily try adding an exception breakpoint to project 1, then changing the call to **`instantiateViewController()`** so that it uses the storyboard identifier “Bad” – this will fail, but your exception breakpoint should catch it.

        ```swift
        if let vc = storyboard?.instantiateViewController(identifier: "Bad") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.currentPicturePosition = indexPath.row + 1
            vc.totalNumberOfPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
        ```

    2. In project 1, add a call to **`assert()`** in the **`viewDidLoad()`** method of DetailViewController.swift, checking that **`selectedImage`** always has a value.

        ```swift
        assert(selectedImage != nil, "We have selected image")
        ```

    3. Go back to project 5, and try adding a conditional breakpoint to the start of the **`submit()`** method that pauses only if the user submits a word with six or more letters.

        We need to add a breakpoint with the following condition

        ```swift
        answer.count >= 6
        ```

**Debug talk: [https://appdevcon.nl/session/how-to-debug-like-a-pro](https://appdevcon.nl/session/how-to-debug-like-a-pro)**