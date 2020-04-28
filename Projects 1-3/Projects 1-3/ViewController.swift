//
//  ViewController.swift
//  Projects 1-3
//
//  Created by Manuel Teixeira on 28/04/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var flags = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Flags"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        loadFlags()
    }
    
    private func loadFlags() {
        let path = Bundle.main.resourcePath!
        let fileManager = FileManager.default
        let items = try! fileManager.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasSuffix("png") {
                let flagName = item.replacingOccurrences(of: "@2x.png", with: "")
                flags.append(flagName)
            }
        }
    }

}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let selectedFlag = flags[indexPath.row]
        
        cell.textLabel?.text = selectedFlag
        
        if let image = UIImage(named: selectedFlag) {
            cell.imageView?.image = image
            cell.imageView?.layer.borderWidth = 1
            cell.imageView?.layer.borderColor = UIColor.darkGray.cgColor
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            
            detailViewController.flagName = flags[indexPath.row].lowercased()
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}

