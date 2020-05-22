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
    
    var selectedImage: Picture?
    var totalNumberOfPictures: Int?
    var currentPicturePosition: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentPicturePosition = currentPicturePosition,
            let totalNumberOfPictures = totalNumberOfPictures {
            title = "Picture \(currentPicturePosition) of \(totalNumberOfPictures)"
        }
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let imageToLoad = selectedImage?.name {
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

}
