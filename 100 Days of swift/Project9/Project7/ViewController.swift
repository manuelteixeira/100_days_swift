//
//  ViewController.swift
//  Project7
//
//  Created by Manuel Teixeira on 08/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performSelector(inBackground: #selector(fetchJSON), with: nil)
        
        let creditsButtonItem = UIBarButtonItem(title: "Credits", style: .plain, target: self, action: #selector(showCredits))
        let filterButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(showFilter))
        let clearButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearFilteredPetitions))
        
        navigationItem.rightBarButtonItem = creditsButtonItem
        navigationItem.leftBarButtonItems = [clearButtonItem, filterButtonItem]
    }
    
    @objc func fetchJSON() {
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
                return
            }
        }
        
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    @objc func showError() {
        let alertController = UIAlertController(title: "Loading error", message: "There was a problem", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
            
        present(alertController, animated: true)
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            petitions = jsonPetitions.results
            filteredPetitions = petitions
            
            tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
        } else {
            performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
        }
    }
    
    @objc func showCredits() {
        let alertController = UIAlertController(title: "Credits", message: "This data came from the We The People API of the whitehouse", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    @objc func showFilter() {
        let alertController = UIAlertController(title: "Filter petitions", message: nil, preferredStyle: .alert)
        
        alertController.addTextField()
        
        let action = UIAlertAction(title: "Filter", style: .default) { [weak self, weak alertController] _ in
            
            guard let self = self,
                let text = alertController?.textFields?[0].text
            else {
                return
            }
            
            self.filterPetitions(text)
        }
        
        alertController.addAction(action)
        
        present(alertController, animated: true)
    }
    
    func filterPetitions(_ text: String) {
        
        filteredPetitions = petitions.filter({ petition -> Bool in
            return petition.title.contains(text)
        })
        
        tableView.reloadData()
    }
    
    @objc func clearFilteredPetitions() {
        filteredPetitions.removeAll()
        filteredPetitions.append(contentsOf: petitions)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredPetitions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = filteredPetitions[indexPath.row].title
        cell.detailTextLabel?.text = filteredPetitions[indexPath.row].body
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailViewController = DetailViewController()
        
        detailViewController.detailItem = filteredPetitions[indexPath.row]
        
        navigationController?.pushViewController(detailViewController, animated: true)
    }

}

