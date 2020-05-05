# Day 18 - Project 1, part three

## **Challenge**

- Use Interface Builder to select the text label inside your table view cell and adjust its font size to something larger – experiment and see what looks good.
- In your main table view, show the image names in sorted order, so “nssl0033.jpg” comes before “nssl0034.jpg”.

    ```swift
    // ViewController.swift
    override func viewDidLoad() {
    		// ...
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
    }
    ```

- Rather than show image names in the detail title bar, show “Picture X of Y”, where Y is the total number of images and X is the selected picture’s position in the array. Make sure you count from 1 rather than 0.

    ```swift
    // DetailViewController.swift
    if let currentPicturePosition = currentPicturePosition,
       let totalNumberOfPictures = totalNumberOfPictures {
        title = "Picture \(currentPicturePosition) of \(totalNumberOfPictures)"
    }
    ```

    ```swift
    // ViewController.swift
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.currentPicturePosition = indexPath.row + 1
            vc.totalNumberOfPictures = pictures.count
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    ```