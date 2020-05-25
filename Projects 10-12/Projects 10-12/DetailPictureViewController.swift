//
//  DetailPictureViewController.swift
//  Projects 10-12
//
//  Created by Manuel Teixeira on 25/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class DetailPictureViewController: UIViewController {
    var picture: Picture!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPicture()
    }
    
    func setupPicture() {
        let pictureFilePath = Utils.getDocumentsPath().appendingPathComponent(picture.fileName)

        let pictureImageView = UIImageView()
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        pictureImageView.image = UIImage(contentsOfFile: pictureFilePath.path)
        pictureImageView.contentMode = .scaleAspectFill
        view.addSubview(pictureImageView)
        
        NSLayoutConstraint.activate([
            pictureImageView.topAnchor.constraint(equalTo: view.topAnchor),
            pictureImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pictureImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pictureImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
