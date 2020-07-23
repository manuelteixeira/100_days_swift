# Day 93 - Project 28, part two

- Challenge

    1. Add a Done button as a navigation bar item that causes the app to re-lock immediately rather than waiting for the user to quit. This should only be shown when the app is unlocked.

        ```swift
        func showDoneBarButton() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMessage))
        }
            
        func hideDoneBarButton() {
            navigationItem.rightBarButtonItem = nil
        }
        ```

    2. Create a password system for your app so that the Touch ID/Face ID fallback is more useful. You'll need to use an alert controller with a text field like we did in project 5, and I suggest you save the password in the keychain!

        ```swift
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
        ```

    3. Go back to project 10 (Names to Faces) and add biometric authentication so the user’s pictures are shown only when they have unlocked the app. You’ll need to give some thought to how you can hide the pictures – perhaps leave the array empty until they are authenticated?

        ```swift
        override func viewDidLoad() {
            super.viewDidLoad()
                    
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authenticationError in
                    DispatchQueue.main.async {
                        if success {
                            self?.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self?.addNewPerson))
                        } else {
                            let ac = UIAlertController(title: "Authentication failed", message: "You could not be verifed; Please try again", preferredStyle: .alert)
                            ac.addAction(UIAlertAction(title: "Ok", style: .default))
                            self?.present(ac, animated: true)
                        }
                    }
                }
            } else {
                let ac = UIAlertController(title: "No biometry available", message: nil, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(ac, animated: true)
            }
        }
        ```