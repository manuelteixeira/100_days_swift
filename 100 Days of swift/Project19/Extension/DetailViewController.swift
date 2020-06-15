//
//  DetailViewController.swift
//  Extension
//
//  Created by Manuel Teixeira on 15/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit
import MobileCoreServices

class DetailViewController: UIViewController {
    
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    var loadScript: Script!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        script = UITextView()
        script.text = loadScript.script
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showPossibleScripts))
        
        let notificationCenter = NotificationCenter.default
        
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    @IBAction func done() {
        saveToUserDefaults()
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }
    
    @objc func showPossibleScripts() {
        let ac = UIAlertController(title: "Scripts", message: "Select your script", preferredStyle: .actionSheet)
        
        ac.addAction(UIAlertAction(title: "Alert", style: .default, handler: { [weak self] _ in
            self?.script.text = "alert('Example')"
        }))
        ac.addAction(UIAlertAction(title: "open", style: .default, handler: { [weak self] _ in
            self?.script.text = "window.open('https://www.google.com')"
        }))
        
        present(ac, animated: true)
    }
    
    func saveToUserDefaults() {
        let ac = UIAlertController(title: "Name the script", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            if let textField = ac.textFields,
                let name = textField[0].text {
                let defaults = UserDefaults.standard
                
                defaults.set(self.script.text, forKey: name)
                
                let item = NSExtensionItem()
                let argument: NSDictionary = ["customJavaScript": self.script.text]
                let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
                let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
                item.attachments = [customJavaScript]
                self.extensionContext?.completeRequest(returningItems: [item])
            }
        }))
        
        present(ac, animated: true)
    }
    
}

