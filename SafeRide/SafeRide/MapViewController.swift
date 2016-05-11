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
        if (self.numberOfPins < 2) {
            if let loc = self.userLocation {
                addLocation(loc)
            }
            else {
                print("Error using current location: User location is not set")
            }
        }
    }
    @IBAction func setPickUp(sender: UITapGestureRecognizer) {
        if (numberOfPins < 2) {
            let tapLocation = sender.locationInView(self.mapView)
            let tapCoordinates = self.mapView.convertPoint(tapLocation, toCoordinateFromView: self.mapView)
            let getLat: CLLocationDegrees = tapCoordinates.latitude
            let getLon: CLLocationDegrees = tapCoordinates.longitude
            let location: CLLocation =  CLLocation(latitude: getLat, longitude: getLon)
        
            addLocation(location)
        }
    }
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.mapView.removeAnnotations(mapView.annotations)
        numberOfPins = 0
        self.navigationBar.prompt = "Set Pickup Location"
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
    private func addressFromCoordinates(location: CLLocation, completionHandler: (address:String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            
            if error != nil {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                completionHandler(address: nil)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks![0]
                let address = self.localizedStringForAddressDictionary(pm.addressDictionary!)
                completionHandler(address: address)
            }
            else {
                print("Problem with the data received from geocoder")
                completionHandler(address: nil)
            }
        })
    }
    
    private func addLocation(loc: CLLocation) -> Void {
        if (self.numberOfPins < 2) {
            addressFromCoordinates(loc) { address in
                let annotation = MKPointAnnotation()
                annotation.coordinate = loc.coordinate
                if (self.numberOfPins < 1) {
                    self.pickUpAddress = address
                    annotation.title = "Pickup"
                    self.navigationBar.prompt = "Set Dropoff Location"
                }
                else {
                    self.dropOffAddress = address
                    annotation.title = "Dropoff"
                    self.navigationBar.prompt = "Press Next to Continue"
                    self.nextButton.enabled = true
                }
                annotation.subtitle = address
                self.mapView.addAnnotation(annotation)
                self.mapView.selectAnnotation(annotation, animated: true)
                self.numberOfPins += 1
            }
        }
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
        
        // Put the search bar in the navigation bar.
        searchController?.searchBar.sizeToFit()
        self.navigationItem.titleView = searchController?.searchBar
        
        // When UISearchController presents the results view, present it in
        // this view controller, not one further up the chain.
        self.definesPresentationContext = true
        
        // Prevent the navigation bar from being hidden when searching.
        searchController?.hidesNavigationBarDuringPresentation = false    }
    
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

