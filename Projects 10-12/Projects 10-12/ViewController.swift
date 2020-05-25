//
//  ViewController.swift
//  Projects 10-12
//
//  Created by Manuel Teixeira on 25/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [Picture]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        load()
        setupUI()
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        
        let picture = pictures[indexPath.row]
        let pictureFilePath = Utils.getDocumentsPath().appendingPathComponent(picture.fileName)
        cell.textLabel?.text = picture.caption
        cell.detailTextLabel?.text = picture.fileName
        cell.imageView?.image = UIImage(contentsOfFile: pictureFilePath.path)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailPictureViewController()
        detailViewController.picture = pictures[indexPath.row]
        
        present(detailViewController, animated: true)
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func takePicture() {
        // change to .camera when on device
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else { return }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let pictureName = UUID().uuidString
        let picturePath = Utils.getDocumentsPath().appendingPathComponent(pictureName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: picturePath)
        }
        
        dismiss(animated: true)
                
        showCaptionAlert(for: pictureName)
    }
}

private extension ViewController {
    func setupUI() {
        let cameraButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(takePicture))
        
        navigationItem.rightBarButtonItem = cameraButtonItem
    }
    
    func showCaptionAlert(for pictureName: String) {
        let captionAlert = UIAlertController(title: "Create your caption", message: nil, preferredStyle: .alert)
        
        captionAlert.addTextField()
        
        captionAlert.addAction(UIAlertAction(title: "Add", style: .default) {
            [weak self, weak captionAlert] _ in
            
            guard let self = self else { return }
            
            if let text = captionAlert?.textFields?[0].text {
                let picture = Picture(fileName: pictureName, caption: text)
                self.pictures.append(picture)
                self.save()
                let indexPath = IndexPath(row: self.pictures.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        })
        
        present(captionAlert, animated: true)
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        let defaults = UserDefaults.standard
        
        do {
            let encodedData = try jsonEncoder.encode(pictures)
            defaults.set(encodedData, forKey: "pictures")
        } catch {
            fatalError("Unable to encode")
        }
    }
    
    func load() {
        let jsonDecoder = JSONDecoder()
        let defaults = UserDefaults.standard
        
        do {
            if let data = defaults.data(forKey: "pictures") {
                pictures = try jsonDecoder.decode([Picture].self, from: data)
            }
        } catch {
            fatalError("Unable to decode")
        }
    }
}
