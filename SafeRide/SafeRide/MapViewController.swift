//
//  MapViewController.swift
//  SafeRide
//
//  Created by Caleb Friden on 3/30/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties (IBOutlet)
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var navigationBar: UINavigationItem!
    
    // MARK: Properties (IBAction)
    @IBAction func setPickUp(sender: UITapGestureRecognizer) {
        if (numberOfPins < 2) {
            let tapLocation = sender.locationInView(self.mapView)
            let tapCoordinates = self.mapView.convertPoint(tapLocation, toCoordinateFromView: self.mapView)
            let annotation = MKPointAnnotation()
        
            annotation.coordinate = tapCoordinates
            if (numberOfPins < 1) {
                annotation.title = "Pickup Location"
                self.navigationBar.title = "Tap to Set Dropoff Location"
            }
            else {
                annotation.title = "Dropoff Location"
                self.navigationBar.title = "Press Next to Continue"

            }
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: false)
            numberOfPins += 1
        }
    }
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.mapView.removeAnnotations(mapView.annotations)
        numberOfPins = 0
        self.navigationBar.title = "Tap to Set Pickup Location"
    }
    
    
    // MARK: Properties (Static)
    
    // UO Coordinates
    let coordinates = CLLocationCoordinate2D(latitude: 44.0459320, longitude: -123.0706070)
    // San Francisco Coordinates for testing
    let coordinates2 = CLLocationCoordinate2D(latitude: 37.7749290, longitude: -122.4194160)

    let locationManager = CLLocationManager()

    // MARK: Properties (Private)
    private var numberOfPins = 0
    private var boundaryOverlay: MKCircle?
    
    
    // MARK: View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.startUpdatingLocation()
            self.mapView.showsUserLocation = true
        }
        
        // Add Safe Ride Boundary Area
        let circle = MKCircle(centerCoordinate: coordinates, radius: 4828.03)
        self.mapView.addOverlay(circle)
        self.boundaryOverlay = circle
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude, location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
        
        self.mapView.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    // MARK: MKMapViewDelegate
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let circleOverlay = overlay as! MKCircle
        let circleRenderer = MKCircleRenderer(overlay: circleOverlay)
        circleRenderer.strokeColor = UIColor.blueColor()
        circleRenderer.lineWidth = 1
        circleRenderer.alpha = 0.5
        
        return circleRenderer
    }

}

