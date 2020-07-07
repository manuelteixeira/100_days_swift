# Day 84 - Project 25, part two

- Challenge

    1. Show an alert when a user has disconnected from our multipeer network. Something like “Paul’s iPhone has disconnected” is enough.

        ```swift
        func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
            switch state {
            case .connected:
                print("Connected: \(peerID.displayName)")
            case .connecting:
                print("Connecting: \(peerID.displayName)")
            case .notConnected:
                print("Not connected: \(peerID.displayName)")
                showDisconnectedUser(name)
            @unknown default:
                print("Unknown state received: \(peerID.displayName)")
            }
        }
        ```

        ```swift
        func showDisconnectedUser(_ name: String) {
            let ac = UIAlertController(title: "Disconnected", message: "The user \(name) disconnected", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
        ```

    2. Try sending text messages across the network. You can create a **`Data`** from a string using **`Data(yourString.utf8)`**, and convert a **`Data`** back to a string by using **`String(decoding: yourData, as: UTF8.self)`**.

        ```swift
        override func viewDidLoad() {
            super.viewDidLoad()
            
            title = "Selfie Share"
            navigationItem.rightBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(sendMessage)),
                UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
            ]
            navigationItem.leftBarButtonItems = [
                UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt)),
                UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showConnectedPeers))
            ]
            
            mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
            mcSession?.delegate = self
        }
        ```

        ```swift
        @objc func sendMessage() {
            let ac = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
            ac.addTextField()
            
            ac.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak self] _ in
                guard
                    let textField = ac.textFields,
                    let text = textField[0].text,
                    let mcSession = self?.mcSession
                else { return }
                
                if mcSession.connectedPeers.count > 0 {
                    do {
                        let messageData = Data(text.utf8)
                        try mcSession.send(messageData, toPeers: mcSession.connectedPeers, with: .reliable)
                    } catch {
                        let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
            }))
            
            present(ac, animated: true)
        }
        ```

        ```swift
        func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
            DispatchQueue.main.async { [weak self] in
                if let image = UIImage(data: data) {
                    self?.images.insert(image, at: 0)
                    self?.collectionView.reloadData()
                }
                
                let message = String(decoding: data, as: UTF8.self)
                print(message)
            }
        }
        ```

    3. Add a button that shows an alert controller listing the names of all devices currently connected to the session – use the **`connectedPeers`** property of your session to find that information.

        ```swift
        navigationItem.leftBarButtonItems = [
            UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt)),
            UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showConnectedPeers))
        ]
        ```

        ```swift
        @objc func showConnectedPeers() {
            guard let mcSession = mcSession else { return }
            
            let list = mcSession.connectedPeers.map { $0.displayName }.joined(separator: "\n")
            let ac = UIAlertController(title: "Connected peers", message: list, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
        ```