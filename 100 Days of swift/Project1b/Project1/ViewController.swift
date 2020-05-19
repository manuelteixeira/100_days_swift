//
//  ViewController.swift
//  Project1
//
//  Created by Manuel Teixeira on 21/04/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareAppTapped))
        
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        pictures.sort()
        print(pictures)
    }
    
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
    
    @objc func shareAppTapped() {
        let message = "Hey you should look at this app."
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: [])
        
        navigationController?.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true)
    }
}

