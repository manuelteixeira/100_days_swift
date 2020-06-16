# Day 73 - Project 21, part two

- Challenge

    1. Update the code in **`didReceive`** so that it shows different instances of **`UIAlertController`** depending on which action identifier was passed in.

        ```swift
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            
            if let customData = userInfo["customData"] as? String {
                print("Custom data received: \(customData)")
                
                switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    let ac = UIAlertController(title: "Default identifier", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(ac, animated: true)
                    // The user swiped to unlock
                    print("Default identifier")
                case "show":
                    let ac = UIAlertController(title: "Show identifier", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(ac, animated: true)
                    print("Show more information")
                default:
                    break
                }
            }
            
            completionHandler()
        }
        ```

    2. For a harder challenge, add a second **`UNNotificationAction`** to the **`alarm`** category of project 21. Give it the title “Remind me later”, and make it call **`scheduleLocal()`** so that the same alert is shown in 24 hours. (For the purpose of these challenges, a time interval notification with 86400 seconds is good enough – that’s roughly how many seconds there are in a day, excluding summer time changes and leap seconds.)

        ```swift
        func registerCategories() {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            let show = UNNotificationAction(identifier: "show", title: "Tell me more", options: .foreground)
            let reminder = UNNotificationAction(identifier: "reminder", title: "Remind me later", options: .foreground)
            let category = UNNotificationCategory(identifier: "alarm", actions: [show, reminder], intentIdentifiers: [])
            
            center.setNotificationCategories([category])
        }
        ```

        ```swift
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            
            if let customData = userInfo["customData"] as? String {
                print("Custom data received: \(customData)")
                
                switch response.actionIdentifier {
                case UNNotificationDefaultActionIdentifier:
                    let ac = UIAlertController(title: "Default identifier", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(ac, animated: true)
                    // The user swiped to unlock
                    print("Default identifier")
                case "show":
                    let ac = UIAlertController(title: "Show identifier", message: nil, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    present(ac, animated: true)
                    print("Show more information")
                case "reminder":
                    let ac = UIAlertController(title: "Remind me later", message: "Ok, I will remind you later", preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak self] _ in
                        self?.scheduleLocal()
                    }))
                    present(ac, animated: true)
                default:
                    break
                }
            }
            
            completionHandler()
        }
        ```

    3. And for an even harder challenge, update project 2 so that it reminds players to come back and play every day. This means scheduling a week of notifications ahead of time, each of which launch the app. When the app is finally launched, make sure you call **`removeAllPendingNotificationRequests()`** to clear any un-shown alerts, then make new alerts for future days.

        ```swift
        func registerForNotifications() {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
                if granted {
                    self?.scheduleNotification()
                }
            }
        }

        func scheduleNotification() {
            let center = UNUserNotificationCenter.current()
            center.removeAllPendingNotificationRequests()
            
            let content = UNMutableNotificationContent()
            content.title = "Play the game"
            content.body = "Come and play! 🎲"
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 17
            dateComponents.minute = 00
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request)
        }
        ```

        ```swift
        override func viewDidLoad() {
        	  // ...
            registerForNotifications()
        }
        ```