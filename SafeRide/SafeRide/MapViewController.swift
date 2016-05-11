//
//  MapViewController.swift
//  SafeRide
//
//  Created by Caleb Friden on 3/30/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import CoreLocation
import Contacts

class MapViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties (IBOutlet)
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    // MARK: Properties (IBAction)
    @IBAction func useMyLocation(sender: AnyObject) {
        if let loc = self.userLocation {
            self.mapView.removeAnnotations(mapView.annotations)
            self.nextButton.enabled = false
            updateAddressFromCoordinates(loc, addressType: "pick up")
            self.navigationBar.title = "Set Dropoff Location"
            numberOfPins = 1
        }
        else {
            print("Error using current location: User location is not set")
        }
    }
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
                self.navigationBar.title = "Set Dropoff Location"
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
        self.navigationBar.title = "Set Pickup Location"
        self.nextButton.enabled = false
    }
    
    
    // MARK: Properties (Public)
    var pickUpAddress: String?
    var dropOffAddress: String?
    var numberOfPins = 0
    var searchController: UISearchController?
    
    // MARK: Properties (Static)
    
    // UO Coordinates
    let coordinates = CLLocationCoordinate2D(latitude: 44.0459320, longitude: -123.0706070)
    // San Francisco Coordinates for testing
    let coordinates2 = CLLocationCoordinate2D(latitude: 37.7749290, longitude: -122.4194160)

    let locationManager = CLLocationManager()

    // MARK: Properties (Private)
    private var resultsViewController: GMSAutocompleteResultsViewController?
    private var resultView: UITextView?
    private var boundaryOverlay: MKCircle?
    private var userLocation: CLLocation?
    
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
                let address = self.localizedStringForAddressDictionary(pm.addressDictionary!)
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
    
    
    // MARK: View Life Cycle
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
        
        // Add Google Maps AutoComplete
        resultsViewController = GMSAutocompleteResultsViewController()
        resultsViewController?.delegate = self
        
        searchController = UISearchController(searchResultsController: resultsViewController)
        searchController?.searchResultsUpdater = resultsViewController
        
        let subView = UIView(frame: CGRectMake(0, 65.0, 350.0, 45.0))
        
        subView.addSubview((searchController?.searchBar)!)
        self.view.addSubview(subView)
        searchController?.searchBar.sizeToFit()
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segue.identifier {
        case .Some("confirmSegue"):
            let viewController = segue.destinationViewController as! ConfirmViewController
            viewController.pickUpAddress = pickUpAddress!
            viewController.dropOffAddress = dropOffAddress!
        default:
            super.prepareForSegue(segue, sender: sender)
        }
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        self.userLocation = location
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
    
    // MARK: Methods (Private)
    func postalAddressFromAddressDictionary(addressdictionary: Dictionary<NSObject,AnyObject>) -> CNMutablePostalAddress {
        // Convert Address Dictionary to CNPostalAddress
        
        let address = CNMutablePostalAddress()
        
        address.street = addressdictionary["Street"] as? String ?? ""
        address.state = addressdictionary["State"] as? String ?? ""
        address.city = addressdictionary["City"] as? String ?? ""
        address.country = addressdictionary["Country"] as? String ?? ""
        address.postalCode = addressdictionary["ZIP"] as? String ?? ""
        
        return address
    }
    
    func localizedStringForAddressDictionary(addressDictionary: Dictionary<NSObject,AnyObject>) -> String {
        // Create a localized address string from an Address Dictionary
        
        return CNPostalAddressFormatter.stringFromPostalAddress(postalAddressFromAddressDictionary(addressDictionary), style: .MailingAddress)
    }

}

