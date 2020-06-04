# Day 60 - Project 16, part one

- **Up and running with MapKit**

    Using the assistant editor, please create an outlet for your map view called **`mapView`**. You should also set your view controller to be the delegate of the map view by Ctrl-dragging from the map view to the orange and white view controller button just above the layout area. You will also need to add **`import MapKit`** to ViewController.swift so it understands what **`MKMapView`** is.

    **Annotations are objects that contain a title, a subtitle and a position**. The first two are both strings, **the third is a new data type** called **`CLLocationCoordinate2D`**, which **is a structure that holds a latitude and longitude for where the annotation should be placed**.

    **Map annotations are described not as a class, but as a protocol**. This is something you haven't seen before, because so far protocols have all been about methods. But **if we want to conform to the MKAnnotation protocol, which is the one we need to adopt in order to create map annotations, it states that we must have a coordinate in our annotation.** That makes sense, because there's no point in having an annotation on a map if we don't know where it is. The title and subtitle are optional, but we'll provide them anyway.

    ```swift
    import MapKit
    import UIKit

    class Capital: NSObject, MKAnnotation {
        var title: String?
        var coordinate: CLLocationCoordinate2D
        var info: String

        init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
            self.title = title
            self.coordinate = coordinate
            self.info = info
        }
    }
    ```

    Put these lines into the **`viewDidLoad()`** method of ViewController.swift:

    ```swift
    let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics.")
    let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thousand years ago.")
    let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light.")
    let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.")
    let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.")
    ```

    These **`Capital`** **objects conform to the `MKAnnotation` protocol**, which **means we can send it to map view for display using the `addAnnotations()` method**. Put this just before the end of **`viewDidLoad()`**:

    ```swift
    mapView.addAnnotations([london, oslo, paris, rome, washington])
    ```

- **Annotations and accessory views: MKPinAnnotationView**

    **Every time the map needs to show an annotation, it calls a `viewFor` method on its delegate**. We don't implement that method right now, so the default red pin is used with nothing special – although as you've seen it's smart enough to pull out the title for us.

    Customizing an annotation view is a little bit like customizing a table view cell or collection view cell, because **iOS automatically reuses annotation views to make best use of memory**. **If there isn't one available to reuse, we need to create one from scratch using the `MKPinAnnotationView` class.**

    There are a couple of things you need to be careful of here. First, **`viewFor`** **will be called for your annotations, but also Apple's.** For example, if you enable tracking of the user's location then that's shown as an annotation and you don't want to try using it as a capital city. I**f an annotation is not one of yours, just return nil from the method to have Apple's default used instead.**

    Second, **adding a button to the view isn't done using the `addTarget()` method**. Instead, you **just add the button and the map view will send a message to its delegate when it's tapped.**

    Here's a breakdown of what the method will do:

    1. **If the annotation isn't from a capital city, it must return `nil` so iOS uses a default view.**
    2. **Define a reuse identifier**. This is a string that will be used to ensure we reuse annotation views as much as possible.
    3. **Try to dequeue an annotation view from the map view's pool of unused views.**
    4. **If it isn't able to find a reusable view, create a new one using `MKPinAnnotationView` and sets its `canShowCallout` property to true**. This triggers the popup with the city name.
    5. Create a new **`UIButton`** using the built-in **`.detailDisclosure`** type. This is a small blue "i" symbol with a circle around it.
    6. **If it can reuse a view, update that view to use a different annotation.**

    ```swift
    class ViewController: UIViewController, MKMapViewDelegate { ... }
    ```

    ```swift
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 1
        guard annotation is Capital else { return nil }

        // 2
        let identifier = "Capital"

        // 3
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

        if annotationView == nil {
            //4
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true

            // 5
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            // 6
            annotationView?.annotation = annotation
        }

        return annotationView
    }
    ```

    If you tap on any pin you'll see a city's name as well as a button you can tap to show more information. Like I said, you don't need to use `addTarget()` to add an action to the button, because **you'll automatically be told by the map view using a `calloutAccessoryControlTapped` method.**

    **The annotation view contains a property called annotation**, **which will contain our Capital object**. So, we can pull that out, typecast it as a **`Capital`**, then show its title and information in any way we want. The easiest for now is just to use a **`UIAlertController`**, so that's what we'll do.

    ```swift
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        let placeName = capital.title
        let placeInfo = capital.info

        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    ```