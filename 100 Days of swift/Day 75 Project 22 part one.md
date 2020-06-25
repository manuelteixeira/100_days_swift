# Day 75 - Project 22, part one

- **Requesting location: Core Location**

    Using location when the app isn’t running is of course highly sensitive information, so Apple flags it up in three ways:

    1. **If you request Always access**, u**sers will still get the chance to choose When In Use.**
    2. **If they choose Always**, **iOS will automatically ask them again after a few days to confirm** they still want to grant Always access.
    3. **When your app is using location data in the background the iOS UI will update to reflect that** – users will know it’s happening.
    4. **Users can, at any point, go into the settings app and change from Always down to When In Use.**

    In this app **we’re going to request Always access so that our app can detect beacons in the background**. Requesting location access requires a **change to your apps Info.plist file**. **We need to add to that file the reason why we want the user’s location** – a string that will be shown in the iOS UI when the user is being asked to accept or decline our request.

    Because of the rules above, **we need to add two keys**: “**`Privacy - Location Always and When In Use Usage Description`**” and “**`Privacy - Location When In Use Usage Description`**”. 

    Open **`ViewController.swift`** and add this import alongside **`UIKit`**:

    ```swift
    import CoreLocation
    ```

    Now add this property to your class:

    ```swift
    var locationManager: CLLocationManager?
    ```

    That doesn't actually create a location manager, or even prompt the user for location permission! To do that, we **first need to create the object**, then **set ourselves as its delegate**, then finally we **need to request authorization**. We'll start by conforming to the protocol, so change your class definition to this:

    ```swift
    class ViewController: UIViewController, CLLocationManagerDelegate { ... }
    ```

    Now modify your **`viewDidLoad()`** method to this:

    ```swift
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        view.backgroundColor = .gray
    }
    ```

    **`requestAlwaysAuthorization()`** is where the actual action happens: if you have already been granted location permission then things will Just Work; if you haven't, iOS will request it now.

    **Note**: if you used the "when in use" key, you should call **`requestWhenInUseAuthorization()`** instead. If you did not set the correct plist key earlier, your request for location access will be ignored.

    **Requesting location authorization is a non-blocking call**, which **means your code will carry on executing** while the user reads your location message and decides whether to grant you access to their location.

    **When the user has finally made their mind, you'll get told their result** because we set ourselves as the delegate for our `CLLocationManager` object. The method that will be called is this one:

    ```swift
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
    ```

- **Hunting the beacon: CLBeaconRegion**

    Assuming everything went well, let's take a look at how we actually range beacons. 

    First, **we use a new class called `CLBeaconRegion`**, which **is used to identify a beacon uniquely**. 

    Second, **we give that to our CLLocationManager object by calling its `startMonitoring(for:)` and `startRangingBeacons(in:)` methods**. Once that's done, we sit and wait. As soon as iOS has anything tell us, it will do so.

    **iBeacons are identified using three pieces of information**: a **universally unique identifier** (UUID), plus a **major number** and a **minor number**. The **first number is a long hexadecimal string** that you can create by running the uuidgen in your Mac's terminal. **It should identify you or your store chain uniquely.**

    The **major number** is **used to subdivide within the UUID**. So, if you have 10,000 stores in your supermarket chain, you would use the same UUID for them all but give each one a different major number. That major number must be between 1 and 65535, which is enough to identify every McDonalds and Starbucks outlet combined!

    The **minor number** can (if you wish) **be used to subdivide within the major number**. For example, if your flagship London store has 12 floors each of which has 10 departments, you would assign each of them a different minor number.

    The combination of all three identify the user's precise location:

    - **UUID:** You're in a Acme Hardware Supplies store.
    - **Major:** You're in the Glasgow branch.
    - **Minor:** You're in the shoe department on the third floor.

    If you don't need that level of detail you can skip minor or even major – it's down to you.

    It's time to put this into code, so we're going to create a new method called `**startScanning()**` that contains the following:

    ```swift
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")

        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    ```

    The UUID I'm using there **is one of the ones that comes built into the Locate Beacon app** – look under "Apple AirLocate 5A4BCFCE" and find it there. Note that I'm scanning for specific major and minor numbers, so please enter those into your Locate Beacon app.

    The **identifier field is just a string you can set to help identify this beacon in a human-readable way**. That, plus the UUID, major and minor fields, goes into the **`CLBeaconRegion`** class, which is used to identify and work with iBeacons. **It then gets sent to our location manager, asking it to monitor for the existence of the region and also to start measuring the distance between us and the beacon.**

    **`didChangeAuthorization`** method change it to this:

    ```swift
    startScanning()
    ```

    This app **is going to change the label text and view background color to reflect proximity to the beacon we're scanning for.** This will be done in a single method, called **`update(distance:)`**, **which will use a switch/case block and animations in order to make the transition look smooth**. Let's write that method first:

    ```swift
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 1) {
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"

            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"
            }
        }
    }
    ```

    Now, i**n theory this can only be be one of our four distance values**, which is why we have a default case in there. **However, Swift should show you a warning because Apple has marked CLProximity as an enum that might change in the future – they might add more fine-grained values, for example.**

    This is only a warning rather than an error because you can build ship your code without covering future cases if you want to. However, if you do that you risk running into problems in the future: if Apple added an extra .farFarAway case in there, what would your code do?

    There are two solutions here: we can add a special case called **`@unknown default`**, which **is specifically there to catch future values**. This allows you to cover all the other cases explicitly, then provide one extra case to handle as-yet-unknown cases in the future:

    ```swift
    @unknown default:
        self.view.backgroundColor = .black
        self.distanceReading.text = "WHOA!"
    ```

    In this app, though, it’s easier to treat unknown future cases as a regular unknown case, so instead I would recommend you write this:

    ```swift
    func update(distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            switch distance {
            case .far:
                self.view.backgroundColor = UIColor.blue
                self.distanceReading.text = "FAR"

            case .near:
                self.view.backgroundColor = UIColor.orange
                self.distanceReading.text = "NEAR"

            case .immediate:
                self.view.backgroundColor = UIColor.red
                self.distanceReading.text = "RIGHT HERE"

            default:
                self.view.backgroundColor = UIColor.gray
                self.distanceReading.text = "UNKNOWN"
            }
        }
    }
    ```

    With that method written, all that remains before our project is complete is to **catch the ranging method from `CLLocationManager`**. **We'll be given the array of beacons it found for a given region, which allows for cases where there are multiple beacons transmitting the same UUID.**

    **If we receive any beacons from this method**, we'll **pull out the first one and use its proximity property to call our `update(distance:)`** method and redraw the user interface. **If there aren't any beacons, we'll just use .unknown**, which will switch the text back to "UNKNOWN" and make the background color gray.

    ```swift
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if let beacon = beacons.first {
            update(distance: beacon.proximity)
        } else {
            update(distance: .unknown)
        }
    }
    ```