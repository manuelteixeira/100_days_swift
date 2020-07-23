//
//  ViewController.swift
//  Project28
//
//  Created by Manuel Teixeira on 22/07/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import LocalAuthentication
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var secret: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMessage()
                        self?.showDoneBarButton()
                    } else {
                        let ac = UIAlertController(title: "Authentication failed", message: "You could not be verifed; Please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            if checkIfPasswordExists() {
                showPasswordPrompt()
            } else {
                savePassword()
            }
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardScreenEnd = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEnd, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
    func unlockSecretMessage() {
        secret.isHidden = false
        title = "Secret stuff!"
        
        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        
        title = "Nothing to see here"
        hideDoneBarButton()
    }
    
    func showDoneBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
    }
    
    func hideDoneBarButton() {
        navigationItem.rightBarButtonItem = nil
    }
    
    func savePassword() {
        let ac = UIAlertController(title: "Choose your password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak ac] _ in
            if let password = ac?.textFields?[0].text {
                KeychainWrapper.standard.set(password, forKey: "password")
            }
        }))
        
        present(ac, animated: true)
    }
    
    func showPasswordPrompt() {
        let ac = UIAlertController(title: "Write your password", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak ac, weak self] _ in
            if let password = ac?.textFields?[0].text,
                let savedPassword = KeychainWrapper.standard.string(forKey: "password"){
                
                if password == savedPassword {
                    self?.unlockSecretMessage()
                }
            }
        }))
        
        present(ac, animated: true)
    }
    
    func checkIfPasswordExists() -> Bool {
        return KeychainWrapper.standard.string(forKey: "password") != nil
    }
}

