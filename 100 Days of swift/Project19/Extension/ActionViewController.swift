//
//  ActionViewController.swift
//  Extension
//
//  Created by Manuel Teixeira on 12/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ActionViewController: UITableViewController {
    
    var scripts = [Script]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        load()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scripts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = scripts[indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.loadScript = scripts[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func load() {
        let defaults = UserDefaults.standard
        
        scripts = defaults.array(forKey: "scripts") as? [Script] ?? [Script]()
    }
    
    @objc func add() {
        let detailViewController = DetailViewController()
        detailViewController.loadScript = Script(name: "Example", script: "alert('example')")
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
