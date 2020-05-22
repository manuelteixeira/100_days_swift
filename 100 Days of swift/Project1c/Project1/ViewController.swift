//
//  ViewController.swift
//  Project1
//
//  Created by Manuel Teixeira on 21/04/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [Picture]()

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
                pictures.append(Picture(name: item, shownCount: 0))
            }
        }
        pictures.sort()
        print(pictures)
        
        load()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        
        cell.textLabel?.text = pictures[indexPath.row].name
        cell.detailTextLabel?.text = "\(pictures[indexPath.row].shownCount)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            vc.currentPicturePosition = indexPath.row + 1
            vc.totalNumberOfPictures = pictures.count
            pictures[indexPath.row].shownCount += 1
            save()
            tableView.reloadRows(at: [indexPath], with: .automatic)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shareAppTapped() {
        let message = "Hey you should look at this app."
        
        let activityController = UIActivityViewController(activityItems: [message], applicationActivities: [])
        
        navigationController?.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        present(activityController, animated: true)
    }
    
    func save() {
        let jsonEnconder = JSONEncoder()
        
        if let savedData = try? jsonEnconder.encode(pictures) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "pictures")
        }
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        if let picturesData = defaults.object(forKey: "pictures") as? Data {
            let jsonDecoder = JSONDecoder()
            
            do {
                pictures = try jsonDecoder.decode([Picture].self, from: picturesData)
            } catch {
                print("Failed to load.")
            }
        }
    }
}

