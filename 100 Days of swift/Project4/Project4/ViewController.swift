//
//  ViewController.swift
//  Project4
//
//  Created by Manuel Teixeira on 29/04/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UITableViewController, WKNavigationDelegate {
    var websites = ["apple.com", "hackingwithswift.com"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = websites[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let url = URL(string: "https://" + websites[indexPath.row]) else { return }
                
        if let detailViewController = storyboard?.instantiateViewController(identifier: "DetailViewController") as? DetailViewController {
            
            detailViewController.url = url
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
}
