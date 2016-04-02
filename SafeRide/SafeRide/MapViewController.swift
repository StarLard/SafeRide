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
import AddressBookUI

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties (IBOutlet)
    @IBOutlet private weak var mapView: MKMapView!
    @IBOutlet private weak var navigationBar: UINavigationItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    // MARK: Properties (IBAction)
    @IBAction func setPickUp(sender: UITapGestureRecognizer) {
        if (numberOfPins < 2) {
            let tapLocation = sender.locationInView(self.mapView)
            let tapCoordinates = self.mapView.convertPoint(tapLocation, toCoordinateFromView: self.mapView)
            let annotation = MKPointAnnotation()
            let getLat: CLLocationDegrees = tapCoordinates.latitude
            let getLon: CLLocationDegrees = tapCoordinates.longitude
            let location: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        
            annotation.coordinate = tapCoordinates
            if (numberOfPins < 1) {
                annotation.title = "Pickup Location"
                self.navigationBar.title = "Tap to Set Dropoff Location"
                updateAddressFromCoordinates(location, addressType: "pick up")
                
            }
            else {
                annotation.title = "Dropoff Location"
                self.navigationBar.title = "Press Next to Continue"
                self.nextButton.enabled = true
                updateAddressFromCoordinates(location, addressType: "drop off")
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
        self.nextButton.enabled = false
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
    private var pickUpAddress = ""
    private var dropOffAddress = ""
    
    // MARK: Methods (Private)
    private func updateAddressFromCoordinates(location: CLLocation, addressType: String){
        if (addressType != "drop off" && addressType != "pick up") {
            print("Error: addressType must be either \"drop off\" or \"pick up\"!")
            return
        }
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                let address = ABCreateStringWithAddressDictionary(pm.addressDictionary!, false)
                if (addressType == "pick up") {
                    self.pickUpAddress = address
                }
                else if (addressType == "drop off") {
                    self.dropOffAddress = address
                }
            }
            else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    
    
    // MARK: View Management
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case .Some("confirmSegue"):
            let viewController = segue.destinationViewController as! ConfirmViewController
            print(pickUpAddress)
            print(dropOffAddress)
            viewController.pickUpAddress = pickUpAddress
            viewController.dropOffAddress = dropOffAddress
        default:
            super.prepareForSegue(segue, sender: sender)
        }
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

