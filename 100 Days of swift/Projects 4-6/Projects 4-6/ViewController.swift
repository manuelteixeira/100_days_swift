//
//  ViewController.swift
//  Projects 4-6
//
//  Created by Manuel Teixeira on 07/05/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(clearShoppingList))
        let addButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addShoppingListItem))
        let shareButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareShoppingList))
        
        navigationItem.rightBarButtonItems = [addButtonItem, shareButtonItem]
    }
}

private extension ViewController {
    @objc func clearShoppingList() {
        shoppingList.removeAll()
        tableView.reloadData()
    }
    
    @objc func addShoppingListItem() {
        let alertController = UIAlertController(title: "Add shopping list item", message: nil, preferredStyle: .alert)
                
        alertController.addTextField()
        
        let action = UIAlertAction(title: "Add", style: .default) { [weak self, weak alertController] _ in
            
            guard let self = self,
                let alertController = alertController,
                let text = alertController.textFields?[0].text
            else { return }
            
            self.submitShoppingListItem(text)
        }
        
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    func submitShoppingListItem(_ item: String) {
        
        shoppingList.append(item)
        let indexPath = IndexPath(row: shoppingList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    @objc func shareShoppingList() {
        
        let sharedShoppingList = shoppingList.joined(separator: "\n")
        let activityController = UIActivityViewController(activityItems: [sharedShoppingList], applicationActivities: [])
        
        present(activityController, animated: true)
    }
}

extension ViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = shoppingList[indexPath.row]
        
        return cell
    }
}

