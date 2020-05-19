# Day 44 - Project 10, part three

- Challenges

    1. Add a second **`UIAlertController`** that gets shown when the user taps a picture, asking them whether they want to rename the person or delete them.

        ```swift
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let person = people[indexPath.item]
            
            let optionsAlertController = UIAlertController(title: "What do you want to do?", message: nil, preferredStyle: .actionSheet)
            
            let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
                
                self?.renamePerson(person)
            }
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
                self?.deletePerson(at: indexPath)
            }
            
            optionsAlertController.addAction(renameAction)
            optionsAlertController.addAction(deleteAction)
            
            present(optionsAlertController, animated: true)
            
        }
        ```

        ```swift
        func renamePerson(_ person: Person) {
            let ac = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
            
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
                
                guard let newName = ac?.textFields?[0].text else { return }
                
                person.name = newName
                
                self?.collectionView.reloadData()
                
            })
            
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            
            present(ac, animated: true)
        }
        ```

        ```swift
        func deletePerson(at indexPath: IndexPath) { 
            people.remove(at: indexPath.item)
            collectionView.deleteItems(at: [indexPath])
        }
        ```

    2. Try using **`picker.sourceType = .camera`** when creating your image picker, which will tell it to create a new image by taking a photo. This is only available on devices (*not on the simulator*) so you might want to check the return value of **`UIImagePickerController.isSourceTypeAvailable()`** before trying to use it!

        ```swift
        @objc func addNewPerson() {
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }

            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.allowsEditing = true
            picker.delegate = self
            
            present(picker, animated: true)
        }
        ```

    3. Modify project 1 so that it uses a collection view controller rather than a table view controller. I recommend you keep a copy of your original table view controller code so you can refer back to it later on.

        ```swift
        class TextCollectionViewCell: UICollectionViewCell {
            
            @IBOutlet weak var nameLabel: UILabel!
        }
        ```

        ```swift
        class ViewController: UICollectionViewController { ... }
        ```

        ```swift
        override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return pictures.count
        }

        override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? TextCollectionViewCell else {
                fatalError("Unable to dequeue")
            }
            
            cell.nameLabel.text = pictures[indexPath.item]
            return cell
        }

        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
                vc.selectedImage = pictures[indexPath.item]
                vc.currentPicturePosition = indexPath.item + 1
                vc.totalNumberOfPictures = pictures.count
                navigationController?.pushViewController(vc, animated: true)
            }
        }
        ```