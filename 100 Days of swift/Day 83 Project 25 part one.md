# Day 83 - Project 25, part one

- **Importing photos again**

    ```swift
    class ViewController: UICollectionViewController { ... }
    ```

    Now **open Main.storyboard** in Interface Builder, then **delete the existing view controller and replace it with a new collection view controller**. Use the attributes inspector to **make it the initial view controller**, **use the identity inspector to give it the class “ViewController”**, then finally **embed it inside a navigation controller.**

    With the **collection view selected**, **set cell size to be 145 wide and 145 high, and give all four section insets a value of 10**. **Click inside the prototype cell** that Xcode made for you and **give it the reuse identifier "ImageView"**. Finally, **drop an image view into the cell so that it occupies all its space, and give it the tag 1000.**

    All the constraints in this project can be made automatically, so select the collection view using the document outline then go to the Editor menu and choose Resolve Auto Layout Issues > Reset to Suggested Constraints.

    To start, **add a right bar button item that uses the system's camera icon and calls an `importPicture()`** method that we'll write shortly. I'm also going to customize the title of the view controller so that it isn't empty, so here's the new **`viewDidLoad()`** method:

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Selfie Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
    }
    ```

    Next, let's make the collection view work correctly, starting with the easy stuff: **make your view controller conform to** the **`UINavigationControllerDelegate`** and **`UIImagePickerControllerDelegate`** protocols, because we need those to work with the image picker.

    **We will store all our apps images inside a `UIImage` array**, so please add this property now:

    ```swift
    var images = [UIImage]()
    ```

    We're going to use that array to know how many items are in our collection view, so you should know to write this method yourself:

    ```swift
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    ```

    Next comes the only thing out of the ordinary in all this code, which is the **`cellForItemAt`** method for our collection view. **When it comes to configuring cells to look correct, we can dequeue using the identifier "ImageView" then find the `UIImageView` inside them without a property.**

    I asked you to set the tag of the image view to be 1000, and here's why: **all `UIView` subclasses have a method called `viewWithTag()`, which searches for any views inside itself (or indeed itself) with that tag number.** We can find our image view just by using this method, although I'll still use **`if let`** and a conditional typecast to be sure.

    Here's the code for **`cellForItemAt`**:

    ```swift
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }

        return cell
    }
    ```

    ```swift
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        images.insert(image, at: 0)
        collectionView.reloadData()
    }
    ```

- **Going peer to peer: MCSession, MCBrowserViewController**

    The next step is to **add a left bar button item** to our view controller, using the **"add" system icon**, and **making it call a method called `showConnectionPrompt()`**. We're going to **make that method ask users whether they want to connect to an existing session with other people**, **or whether they want to create their own**. Here's the code for the bar button item – put this in **`viewDidLoad()`**:

    ```swift
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    ```

    Asking users to clarify how they want to take an action is of course the purpose of UIAlertController as an action sheet, and our **`showConnectionPrompt()`** method is going to use one to ask users what kind of connection they want to make. Put this code into your view controller:

    ```swift
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    ```

    Now, here's where it gets trickier. **Multipeer connectivity requires four new classes:**

    1. **`MCSession`** is the **manager class that handles all multipeer connectivity for us.**
    2. **`MCPeerID`** **identifies each user uniquely in a session.**
    3. **`MCAdvertiserAssistant`** is **used when creating a session**, **telling others that we exist and handling invitations.**
    4. **`MCBrowserViewController`** is **used when looking for sessions, showing users who is nearby and letting them join.**

    We're going to use all four of them in our app, but only three need to be properties.

    Start by importing the multipeer framework:

    ```swift
    import MultipeerConnectivity
    ```

    Now add these to your view controller:

    ```swift
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    ```

    **Although both the session and advertiser assistant are optional, that code creates the `MCPeerID` up front using the name of the current device**, which will usually be something like "Paul's iPhone" – **there’s no need to make an optional for that.**

    **Depending on what users select in our alert controller, we need to call one of two methods**: **`startHosting()`** or **`joinSession()`**. **Because both of these are coming from the result of a `UIAction` being tapped, both methods must accept a** **`UIAlertAction`** as their only parameter.

    Before I show you the code to get multipeer connectivity up and running, I want to go over what they will do. **Most important of all is that all multipeer services on iOS must declare a service type, which is a 15-digit string that uniquely identify your service**. Those 15 digits can contain only the letters A-Z, numbers and hyphens, and it's usually preferred to include your company in there somehow.

    Apple's example is, "a text chat app made by ABC company could use the service type **`abc-txtchat`**"; for this project I'll be using **`hws-project25`**.

    **This service type is used by both `MCAdvertiserAssistant` and `MCBrowserViewController` to make sure your users only see other users of the same app**. **They both also want a reference to your `MCSession` instance so they can take care of connections for you.**

    We're going to start by initializing our **`MCSession`** so that we're able to make connections. Put this code into **`viewDidLoad()`**:

    ```swift
    mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
    mcSession?.delegate = self
    ```

    Our peer ID is used to create the session, along with the encryption option of **`.required`** to ensure that any data transferred is kept safe.

    Don't worry about conforming to any extra protocols just yet; we'll do that in just a minute.

    At this point, the code for **`startHosting()`** and **`joinSession()`** will look quite trivial. Here goes:

    ```swift
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }

    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    ```

    **We're making our view controller the delegate of a second object**, so **that's two protocols we need to conform to in order to fix our current compile failures**. Easily done: add **`MCSessionDelegate`** and **`MCBrowserViewControllerDelegate`** to your class definition… and now there are even more errors, because we need to implement lots of new methods.

- **Invitation only: MCPeerID**

    Merely by saying that we conform to the **`MCSessionDelegate`** and **`MCBrowserViewControllerDelegate`** protocols, your code won't build any more. **This is because the two protocols combined have seven required methods that you need to implement just to be compatible.**

    Helpfully, for **this project you can effectively ignore three of them**, two more are trivial, and one further is just for diagnostic information in this project. That leaves only one method that is non-trivial and important to the program.

    Let's tackle the ones we can effectively ignore. Of course, **you can't *ignore* required methods, otherwise they wouldn't be required. But these methods aren't ones that do anything useful to our program, so we can just create empty methods**. Remember, once you've said you conform to a protocol, Xcode's code completion is updated so you can just start typing the first few letters of a method name in order to have Xcode prompt you with a list to choose from.

    Here are the three methods that we need to provide, but don't actually need any code inside them:

    ```swift
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

    }

    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

    }

    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

    }
    ```

    The two methods we're going to implement that are trivial are both for the multipeer browser: **one is called when it finishes successfully, and one when the user cancels**. **Both methods just need to dismiss the view controller that is currently being presented**, which means this is their entire code:

    ```swift
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }

    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    ```

    There are two methods left: **one that is used in this project only for diagnostic information, and one that's actually useful**. Let's eliminate the diagnostic method first so that we can focus on the interesting bit.

    **When a user connects or disconnects from our session**, the method **`session(_:peer:didChangeState:)`** **is called so you know what's changed** – is someone connecting, are they now connected, or have they just disconnected? We're not going to be using this information in the project, but I do want to show you how it might be used by printing out some diagnostics. This is helpful for debugging, because it means you can look in Xcode's debug console to see these messages and know your code is working.

    **When this method is called, you'll be told what peer changed state, and what their new state is.** There are only three possible session states: not connected, connecting, and connected. So, we can make our app print out useful information just by using switch/case and a bit of **`print()`**:

    ```swift
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")

        case .connecting:
            print("Connecting: \(peerID.displayName)")

        case .notConnected:
            print("Not Connected: \(peerID.displayName)")

        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    ```

    There’s one final case in there to **handle any unknown cases that crop up in the future**. While we *could* have made one of the other cases handle that using a regular **`default`** case, in this project none of them really make sense for whatever might occur in the future so I’ve added a dedicated **`@unknown default`** case to handle future cases.

    That just leaves one more method that must be implemented before you're fully compliant with the protocols, but before I talk you through it you need to know how the core of this app works. It's not hard, but it is important, so listen carefully!

    Right now, when we add a picture to the collection view it is shown on our screen but doesn't go anywhere. **We're going to add some code to the image picker's `didFinishPickingMediaWithInfo` method so that when an image is added it also gets sent out to peers.**

    Sending images across a multipeer connection is remarkably easy. In project 10 we used the function **`jpegData()`** to convert a **`UIImage`** object into a **`Data`** so it can be saved to disk, and **here we’ll be using `pngData()` that does the same thing with the PNG image format. Once we have that, `MCSession` objects have a `sendData()` method that will ensure that data gets transmitted reliably to your peers.**

    **Once the data arrives at each peer, the method `session(_:didReceive:fromPeer:)` will get called with that data, at which point we can create a `UIImage` from it and add it to our `images` array.** There is one catch: **when you receive data it might not be on the main thread**, and **you never manipulate user interfaces anywhere but the main thread**, right? Right.

    Here's the final protocol method, to catch data being received in our session:

    ```swift
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in    
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    ```

    Take note of the call to **`async()`** to ensure we definitely only manipulate the user interface on the main thread!

    The final piece of code to finish up this whole project is the bit that sends image data to peers. This is so easy you might not even believe me. In fact, the code is only as long as it is because there's some error checking in there.

    This final code needs to:

    1. **Check if we have an active session we can use.**
    2. **Check if there are any peers** to send to.
    3. **Convert the new image to a `Data` object**.
    4. **Send it to all peers**, ensuring it gets delivered.
    5. **Show an error message if there's a problem**.

    Converting that into code, you get the below. Put this into your **`didFinishPickingMediaWithInfo`** method, just after the call to **`reloadData()`**:

    ```swift
    // 1
    guard let mcSession = mcSession else { return }

    // 2
    if mcSession.connectedPeers.count > 0 {
        // 3
        if let imageData = image.pngData() {
            // 4
            do {
                try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                // 5
                let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "OK", style: .default))
                present(ac, animated: true)
            }
        }
    }
    ```

    Yes, **the code to ensure data gets sent intact to all peers, as opposed to having some parts lost in the ether, is just to use transmission mode `.reliable`** – nothing more.

    **It’s possible that sending data might throw errors, so we need to surround our code in a `do/catch` block as shown above.** When any error is thrown in the **`do`** block, Swift immediately jumps straight to the **`catch`** block where you can handle it – or in our case show a message. Swift automatically creates an **`error`** constant telling you what went wrong.

    Anyway, I hope you'll agree that the multipeer connectivity framework is super easy to use. The **advertiser assistant takes care of telling the world that our app is looking for connections, as well as handling people who want to join**. The **browser controller takes care of finding all compatible sessions, and sending invitations**. 

    **Remember: to test your project, you'll need to either run it on multiple devices, or use one device and one simulator.**