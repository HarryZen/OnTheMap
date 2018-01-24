//
//  ViewController.swift
//  OnTheMap
//
//  Created by HarryZen on 2018/1/18.
//  Copyright © 2018年 harry. All rights reserved.
//

import UIKit
import MapKit

class MKMapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var locations: [[String: AnyObject]] = []
    var annotations: [MKPointAnnotation] = []
    var appDelegate: AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.locations = appDelegate.locations
        for location in locations {
            
            let lat = CLLocationDegrees(location["latitude"] as! Double)
            let long = CLLocationDegrees(location["longitude"] as! Double)
            
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = location["firstName"] as! String
            let last = location["lastName"] as! String
            let mediaURL = location["mediaURL"] as! String
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        
        // When the array is complete, we add the annotations to the map.
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotations)
        }
//        self.mapView.addAnnotations(annotations)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }else {
            pinView?.annotation = annotation
        }

        return pinView
    }

    
}

