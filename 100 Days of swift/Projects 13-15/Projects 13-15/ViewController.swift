//
//  ViewController.swift
//  Projects 13-15
//
//  Created by Manuel Teixeira on 03/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var countries = [Country]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
        loadCountries()
    }
}

extension ViewController {
    private func setup() {
        title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
        view.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
    }
    
    private func loadCountries() {
        let decoder = JSONDecoder()
        
        if let path = Bundle.main.path(forResource: "countries", ofType: "json") {
            do {
                let url = URL(fileURLWithPath: path)
                let data = try Data(contentsOf: url)
                countries = try decoder.decode([Country].self, from: data)
            } catch {
                print("Error")
            }
        }
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = countries[indexPath.row].name
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = UIColor(red: 104/255, green: 134/255, blue: 197/255, alpha: 1)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let detailCountryViewController = storyboard?.instantiateViewController(identifier: "DetailCountryTableViewController") as? DetailCountryTableViewController {
            
            detailCountryViewController.country = countries[indexPath.row]
            
            navigationController?.pushViewController(detailCountryViewController, animated: true)
        }
    }
}
