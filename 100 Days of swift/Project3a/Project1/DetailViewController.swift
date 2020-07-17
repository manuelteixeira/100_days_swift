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
        
        guard let decodedImage = UIImage(data: image) else { return }
        let watermarkedImage = drawWatermark(image: decodedImage)
        
        let title = selectedImage
        
        let activityController = UIActivityViewController(activityItems: [watermarkedImage, title], applicationActivities: [])
        
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true)
    }

    func drawWatermark(image: UIImage) -> UIImage {
        let size = CGSize(width: image.size.width, height: image.size.height)
        
        let renderer = UIGraphicsImageRenderer(size: size)
        
        let finalImage = renderer.image { context in
            image.draw(at: CGPoint(x: 0, y: 0))
            
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .backgroundColor: UIColor.darkGray,
                .foregroundColor: UIColor.white
            ]
            
            let string = "From Storm Viewer"
            let attributedString = NSAttributedString(string: string, attributes: attributes)
            
            attributedString.draw(at: CGPoint(x: 10, y: 10))
        }
        
        return finalImage
    }
}
