//
//  DetailViewController.swift
//  Projects 19-21
//
//  Created by Manuel Teixeira on 18/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit

protocol SaveNotesDelegate {
    func save(note: Note)
}

class DetailViewController: UIViewController, UITextViewDelegate {
    var textView: UITextView!

    var note = Note()
    var saveNotesDelegate: SaveNotesDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        title = note.title
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        
        navigationController?.navigationBar.tintColor = UIColor(red: 202/255, green: 174/255, blue: 85/255, alpha: 1)
        navigationItem.largeTitleDisplayMode = .never
        let saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(createNoteName))
        let shareBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareNote))
        navigationItem.rightBarButtonItems = [shareBarButtonItem, saveBarButtonItem]
        navigationItem.rightBarButtonItems?.forEach({ $0.tintColor = UIColor(red: 202/255, green: 174/255, blue: 85/255, alpha: 1) })
        
        textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.backgroundColor = .clear
        textView.text = note.body
        textView.delegate = self
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
    }
    
    @objc private func createNoteName() {
        if note.title == nil {
            let alertViewController = UIAlertController(title: "Save note", message: nil, preferredStyle: .alert)
            alertViewController.addTextField()
            let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] _ in
                guard let self = self else { return }
                
                if let textFields = alertViewController.textFields,
                    let text = textFields[0].text {
                    
                    self.note.title = text
                    self.saveNotesDelegate.save(note: self.note)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            alertViewController.addAction(saveAction)
            present(alertViewController, animated: true)
        } else {
            saveNotesDelegate.save(note: note)
            navigationController?.popViewController(animated: true)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        note.body = textView.text
    }
    
    @objc func shareNote() {
        let activityViewController = UIActivityViewController(activityItems: [note.body], applicationActivities: [])
        present(activityViewController, animated: true)
    }
}
