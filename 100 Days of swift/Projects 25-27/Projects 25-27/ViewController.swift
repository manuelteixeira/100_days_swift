//
//  ViewController.swift
//  Projects 25-27
//
//  Created by Manuel Teixeira on 20/07/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit
import CoreGraphics

enum MessageLocation {
    case top
    case bottom
}

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var memes = [Meme]()
    
    var topText: String?
    var bottomText: String?
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension ViewController {
    private func setup() {
        title = "Meme generator 🤹‍♂️"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(selectImage))
        
    }
    
    @objc private func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true)
    }
}

extension ViewController {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.editedImage] as? UIImage {
            
            dismiss(animated: true)
            selectedImage = image
            showTopAlert()
        }
    }
    
    private func showTopAlert() {
        let ac = UIAlertController(title: "Write for the top caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        var caption: String?
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            caption = ac?.textFields?[0].text
            self?.topText = caption
            self?.dismiss(animated: true)
            
            self?.showBottomAlert()
        }
        
        ac.addAction(action)
        present(ac, animated: true)
    }

    private func showBottomAlert() {
        let ac = UIAlertController(title: "Write for the bottom caption", message: nil, preferredStyle: .alert)
        ac.addTextField()
        var caption: String?
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self, weak ac] action in
            caption = ac?.textFields?[0].text
            self?.bottomText = caption
            self?.dismiss(animated: true)
            
            let meme = Meme(topMessage: self?.topText, bottomMessage: self?.bottomText, image: self?.selectedImage)
            self?.memes.append(meme)
            self?.collectionView.reloadData()
        }
        
        ac.addAction(action)
        present(ac, animated: true)
    }
}

extension ViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? MemeCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.imageView.image = memes[indexPath.item].image
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as? MemeDetailViewController {
            
            detailViewController.meme = memes[indexPath.item]
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
