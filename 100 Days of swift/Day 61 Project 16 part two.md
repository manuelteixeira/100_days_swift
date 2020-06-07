# Day 61 - Project 16, part two

- **Challenge**
    1. Try typecasting the return value from **`dequeueReusableAnnotationView()`** so that it's an **`MKPinAnnotationView`**. Once that’s done, change the **`pinTintColor`** property to your favorite **`UIColor`**.

        ```swift
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        annotationView?.pinTintColor = .purple
        ```

    2. Add a **`UIAlertController`** that lets users specify how they want to view the map. There's a **`mapType`** property that draws the maps in different ways. For example, **`.satellite`** gives a satellite view of the terrain.

        ```swift
        func setup() {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(changeTypeMap))
        }

        @objc func changeTypeMap() {
            let ac = UIAlertController(title: "Change map", message: "Please choose a map type", preferredStyle: .actionSheet)
            
            ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { [weak self] _ in
                self?.mapView.mapType = .satellite
            }))
            
            ac.addAction(UIAlertAction(title: "Standard", style: .default, handler: { [weak self] _ in
                self?.mapView.mapType = .standard
            }))
            
            present(ac, animated: true)
        }
        ```

    3. Modify the callout button so that pressing it shows a new view controller with a web view, taking users to the Wikipedia entry for that city.

        ```swift
        import UIKit
        import WebKit

        class WebDetailViewController: UIViewController {
            var capital: Capital!
            var webView: WKWebView!

            override func viewDidLoad() {
                super.viewDidLoad()
                
                webView = WKWebView()
                view = webView
                
                guard
                    let capitalName = capital.title,
                    let url = URL(string: "https://en.wikipedia.org/wiki/\(capitalName)")
                else { return }
                
                let urlRequest = URLRequest(url: url)
                webView.load(urlRequest)
            }
        }
        ```

        ```swift
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let capital = view.annotation as? Capital else { return }
            
            let detailViewController = WebDetailViewController()
            detailViewController.capital = capital
            
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        ```