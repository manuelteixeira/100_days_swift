# Day 72 - Project 21, part one

- **Scheduling notifications: UNUserNotificationCenter and UNNotificationRequest**

    ```swift
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
    ```

    First, **you can't post messages to the user's lock screen unless you have their permission**. 

    So, in order to send local notifications in our app, **we first need to request permission**, and that's what we'll put in the `registerLocal()` method. **You register your settings based on what you actually need**, and **that's done with a method called** **`requestAuthorization()`** on **`UNUserNotificationCenter`**. For this example **we're going to request an alert** (a message to show), **along with a badge** (for our icon) **and a sound** (because users just love those.)

    **You also need to provide a closure that will be executed when the user has granted or denied your permissions request**. **This will be given two parameters**: a **boolean** that will be **true if permission was granted**, and an **`Error?` containing a message if something went wrong.**

    ```swift
    import UserNotifications
    ```

    ```swift
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh")
            }
        }
    }
    ```

    **`scheduleLocal()`** **will configure all the data needed to schedule a notification**, which is **three things**: 

    - content (what to show),
    - a trigger (when to show it),
    - and a request (the combination of content and trigger.)

    First, **the reason a notification request is split into two smaller components is because they are interchangeable**. For example, t**he trigger** – when to show the notification – **can be a calendar trigger** that **shows the notification at an exact time**, it **can be an interval trigger** that **shows the notification after a certain time interval** has lapsed, **or it can be a geofence** that **shows the notification based on the user’s location.**

    **Calendar triggers requires** learning another new data type called **`DateComponents`**. Where you **specify a day, a month, an hour, a minute**, or any combination of those to produce specific times. **For example, if you specify hour 8 and minute 30, and don’t specify a day, it means either “8:30 tomorrow” or “8:30 every day” depending on whether you ask for the notification to be repeated.**

    ```swift
    var dateComponents = DateComponents()
    dateComponents.hour = 10
    dateComponents.minute = 30
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
    ```

    When it comes to **what to show,** **we need to use** the class **`UNMutableNotificationContent`**. This has lots of properties that customize the way the alert looks and works – we’ll be using these:

    - The **`title`** property is used for the **main title of the alert**. This should be a couple of words at most.
    - The **`body`** property should **contain your main text**.
    - If you want to specify a sound you can create a custom **`UNNotificationSound`** object and attach it to the **`sound`** property, or just use **`UNNotificationSound.default`**.
    - To attach custom data to the notification, e.g. an internal ID, use the **`userInfo`** dictionary property.
    - You can also attach custom actions by specifying the **`categoryIdentifier`** property.

    ```swift
    let content = UNMutableNotificationContent()
    content.title = "Title goes here"
    content.body = "Main text goes here"
    content.categoryIdentifier = "customIdentifier"
    content.userInfo = ["customData": "fizzbuzz"]
    content.sound = UNNotificationSound.default
    ```

    The combination of content and trigger is enough to be combined into a request, but here notifications get clever: as well as content and a trigger, **each notification also has a unique identifier**. This is just a string you create, but it does need to be unique because **it lets you update or remove notifications programmatically.**

    Apple’s example for this is an **app that displays live sports scores to the user**. When something interesting happens, **what the user really wants is for the existing notification to be updated with new information, rather than have multiple notifications from the same app over time.**

    **We don’t care what name is used for each notification**, but we do want it to be unique. So, **we’ll be using the UUID class to generate unique identifiers.**

    ```swift
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()

        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    ```

    You can **cancel pending notifications** – i.e., notifications you have scheduled that have yet to be delivered because their trigger hasn’t been met – **using the `center.removeAllPendingNotificationRequests()`** method, like this:

    ```swift
    center.removeAllPendingNotificationRequests()
    ```

    Second, **chances are you’ll find the interval trigger far easier to test with than the calendar trigger, because you can set it to a low number like 5 seconds to have your notification trigger almost immediately.**

    ```swift
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
    ```

- **Acting on responses**

    There’s a lot more you can do with notifications, but chances are the thing you most want to do is act on the user’s response – to show one or more options alongside your alert, then respond to the user’s choice.

    We already set the **`categoryIdentifier`** property for our notification, which **is a text string that identifies a type of alert**. **We can now use that same text string to create buttons for the user to choose from, and iOS will show them when any notifications of that type are shown.**

    This is done using two new classes: **`UNNotificationAction` creates an individual button for the user to tap, and `UNNotificationCategory` groups multiple buttons together under a single identifier.**

    For this technique project **we’re going to create one button**, “Show me more…”, **that will cause the app to launch when tapped**. **We’re also going to set the `delegate` property of the user notification center to be `self`**, **meaning that any alert-based messages that get sent will be routed to our view controller to be handled.**

    Creating a **`UNNotificationAction`** requires three parameters:

    1. An **identifier**, which is a **unique text string that gets sent to you when the button is tapped.**
    2. A **title**, which is what user’s see in the interface.
    3. **Options**, which **describe any special options that relate to the action**. You can choose from **`.authenticationRequired`**, **`.destructive`**, and **`.foreground`**.

    **Once you have as many actions as you want, you group them together into a single `UNNotificationCategory`** **and give it the same identifier you used with a notification.**

    ```swift
    func registerCategories() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self

        let show = UNNotificationAction(identifier: "show", title: "Tell me more…", options: .foreground)
        let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])

        center.setNotificationCategories([category])
    }
    ```

    **Now that we have registered the “alarm” category with a single button**, the **last thing to do is implement the `didReceive` method for the notification cente**r. This is triggered on our view controller because we’re the center’s delegate, so it’s down to us to decide how to handle the notification.

    **When the user acts on a notification you can read its actionIdentifier property to see what they did**. **We have** a single button with the **“show” identifier, but** **there’s also `UNNotificationDefaultActionIdentifier` that gets sent when the user swiped on the notification to unlock their device and launch the app.**

    So: **we can pull out our user info then decide what to do based on what the user chose**. **The method also accepts a completion handler closure that you should call once you’ve finished doing whatever you need to do.** This might be much later on, so it’s marked with the `@escaping` keyword.

    ```swift
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // pull out the buried userInfo dictionary
        let userInfo = response.notification.request.content.userInfo

        if let customData = userInfo["customData"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                // the user swiped to unlock
                print("Default identifier")

            case "show":
                // the user tapped our "show more info…" button
                print("Show more information…")

            default:
                break
            }
        }

        // you must call the completion handler when you're done
        completionHandler()
    }
    ```