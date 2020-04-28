//
//  DetailViewController.swift
//  Projects 1-3
//
//  Created by Manuel Teixeira on 28/04/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var flagName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        
    }
    
    private func configure() {
        guard let flagName = flagName else {
            return
        }
        
        imageView.image = UIImage(named: flagName)
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.darkGray.cgColor
        
        title = flagName.capitalized
        
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
    }
    
    @objc func shareTapped() {
        guard
            let flagName = flagName,
            let image = UIImage(named: flagName)
        else {
            return
        }
        
        let title = flagName.capitalized
        
        let activityController = UIActivityViewController(activityItems: [title, image], applicationActivities: [])
        
        activityController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true)
    }

}
