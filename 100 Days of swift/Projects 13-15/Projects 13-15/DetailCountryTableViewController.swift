//
//  DetailCountryTableViewController.swift
//  Projects 13-15
//
//  Created by Manuel Teixeira on 03/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class DetailCountryTableViewController: UITableViewController {
    
    var country: Country!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension DetailCountryTableViewController {
    private func setup() {
        title = country.name
        navigationItem.largeTitleDisplayMode = .never
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareCountryDetails))
    }
    
    @objc private func shareCountryDetails() {
        let activityViewController = UIActivityViewController(activityItems: [country.name, country.population, country.capital, country.ISO], applicationActivities: nil)
        
        present(activityViewController, animated: true)
    }
}

extension DetailCountryTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath)
        
        cell.textLabel?.text = """
            Name: \(country.name)
            Capital: \(country.capital)
            Population: \(country.population)
            ISO: \(country.ISO)
        """
        
        return cell
    }
}
