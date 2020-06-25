# Day 76 - Project 22, part two

- Challenge
    1. Write code that shows a **`UIAlertController`** when your beacon is first detected. Make sure you set a Boolean to say the alert has been shown, so it doesn’t keep appearing.

        ```swift
        func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
            if let beacon = beacons.first {
                if !alertWasShow {
                    alertWasShow = true
                    let ac = UIAlertController(title: "Hello", message: nil, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default, handler: nil)
                    ac.addAction(action)
                    present(ac, animated: true)
                }
                update(distance: beacon.proximity)
            } else {
                update(distance: .unknown)
            }
        }
        ```

    2. Go through two or three other iBeacons in the Detect Beacon app and add their UUIDs to your app, then register all of them with iOS. Now add a second label to the app that shows new text depending on which beacon was located.

        // Can't do that since i don't have a device atm

    3. Add a circle to your view, then use animation to scale it up and down depending on the distance from the beacon – try 0.001 for unknown, 0.25 for far, 0.5 for near, and 1.0 for immediate. You can make the circle by adding an image, or by creating a view that’s 256 wide by 256 high then setting its **`layer.cornerRadius`** to 128 so that it’s round.

        ```swift
        override func viewDidLoad() {
            super.viewDidLoad()
            
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.requestAlwaysAuthorization()
            
            circle = UIView(frame: CGRect(x: 0, y: 0, width: 256, height: 256))
            circle.layer.cornerRadius = 128
            circle.backgroundColor = .darkGray
            circle.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(circle)

            NSLayoutConstraint.activate([
                circle.bottomAnchor.constraint(equalTo: distanceReading.topAnchor, constant: -20),
                circle.centerXAnchor.constraint(equalTo: distanceReading.centerXAnchor),
                circle.widthAnchor.constraint(equalToConstant: 256),
                circle.heightAnchor.constraint(equalToConstant: 256)
            ])
            
            view.backgroundColor = .gray
        }
        ```

        ```swift
        func update(distance: CLProximity) {
            UIView.animate(withDuration: 1) {
                switch distance {
                case .far:
                    self.view.backgroundColor = .blue
                    self.distanceReading.text = "FAR"
                    self.circle.transform = CGAffineTransform(scaleX: 0.25, y: 0.25)
                case .near:
                    self.view.backgroundColor = .orange
                    self.distanceReading.text = "NEAR"
                    self.circle.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                case .immediate:
                    self.view.backgroundColor = .red
                    self.distanceReading.text = "RIGHT HERE"
                    self.circle.transform = CGAffineTransform(scaleX: 1, y: 1)
                default:
                    self.view.backgroundColor = .gray
                    self.distanceReading.text = "UNKNOWN"
                    self.circle.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                }
            }
        }
        ```