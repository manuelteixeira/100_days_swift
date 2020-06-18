//
//  ViewController.swift
//  Projects 19-21
//
//  Created by Manuel Teixeira on 18/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController, SaveNotesDelegate {
    
    var notes = [Note]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        load()
    }
    
    private func setupView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Notes"
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(navigateToDetailViewController))
        navigationItem.rightBarButtonItem?.tintColor = UIColor(red: 202/255, green: 174/255, blue: 85/255, alpha: 1)
    }
    
    private func load() {
        let decoder = JSONDecoder()
        let defaults = UserDefaults.standard
        
        guard let data = defaults.data(forKey: "Notes") else { return }
        
        do {
            notes = try decoder.decode([Note].self, from: data)
        } catch {
            let errorAlertController = UIAlertController(title: "Error", message: "An error occurred while loading notes", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            errorAlertController.addAction(action)
            
            present(errorAlertController, animated: true)
        }
    }
    
    func save(note: Note) {
        if let noteIndex = notes.firstIndex(where: { $0.id == note.id }) {
            notes[noteIndex] = note
//            let indexPath = IndexPath(row: noteIndex, section: 0)
//            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            notes.append(note)
//            let indexPath = IndexPath(row: notes.count, section: 0)
//            tableView.insertRows(at: [indexPath], with: .automatic)
        }
        
        tableView.reloadData()
        
        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard
        
        if let encodedData = try? encoder.encode(notes) {
            defaults.set(encodedData, forKey: "Notes")
        }
    }
    
    @objc private func navigateToDetailViewController() {
        let detailViewController = DetailViewController()
        detailViewController.saveNotesDelegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}

extension MainTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NoteCell", for: indexPath)
        let selectedNote = notes[indexPath.row]
        
        cell.textLabel?.text = selectedNote.title
        cell.detailTextLabel?.text = selectedNote.date?.description ?? "No date"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        detailViewController.note = notes[indexPath.row]
        detailViewController.saveNotesDelegate = self
        navigationController?.pushViewController(detailViewController, animated: true)
    }
}
