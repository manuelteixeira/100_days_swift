//
//  ViewController.swift
//  Project22
//
//  Created by Manuel Teixeira on 25/06/2020.
//  Copyright © 2020 Manuel Teixeira. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var distanceReading: UILabel!
    var circle: UIView!
    
    var locationManager: CLLocationManager?
    var alertWasShow = false
    
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(uuid: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager?.startMonitoring(for: beaconRegion)
        locationManager?.startRangingBeacons(in: beaconRegion)
    }
    
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
}

