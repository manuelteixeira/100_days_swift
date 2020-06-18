# Day 74 - Milestone: Projects 19-21

- Challenge

    Your challenge for this milestone is to use those API to imitate Apple as closely as you can: I’d like you to recreate the iOS Notes app. I suggest you follow the iPhone version, because it’s fairly simple: a navigation controller, a table view controller, and a detail view controller with a full-screen text view.

    How much of the app you imitate is down to you, but I suggest you work through this list:

    1. Create a table view controller that lists notes. Place it inside a navigation controller. (Project 1)
    2. Tapping on a note should slide in a detail view controller that contains a full-screen text view. (Project 19)
    3. Notes should be loaded and saved using **`Codable`**. You can use **`UserDefaults`** if you want, or write to a file. (Project 12)
    4. Add some toolbar items to the detail view controller – “delete” and “compose” seem like good choices. (Project 4)
    5. Add an action button to the navigation bar in the detail view controller that shares the text using **`UIActivityViewController`**. (Project 3)