//
//  DetailViewController.swift
//  Project1
//
//  Created by Manuel Teixeira on 22/04/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    var totalNumberOfPictures: Int?
    var currentPicturePosition: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentPicturePosition = currentPicturePosition,
            let totalNumberOfPictures = totalNumberOfPictures {
            title = "Picture \(currentPicturePosition) of \(totalNumberOfPictures)"
        }
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let title = selectedImage
        
        let activityController = UIActivityViewController(activityItems: [image, title], applicationActivities: [])
        
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true)
    }

}
