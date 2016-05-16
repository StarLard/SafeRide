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

class MapViewController: UIViewController, GMSMapViewDelegate, UISearchBarDelegate, CLLocationManagerDelegate {
    
    // MARK: Properties (IBOutlet)
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var googleMapView: GMSMapView!
    
    
    // MARK: Properties (IBAction)
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.googleMapView?.clear()
        // Add Safe Ride Boundary Area
        let circleCenter = CLLocationCoordinate2D(latitude: UOCoordinates.latitude, longitude: UOCoordinates.longitude)
        let circ = GMSCircle(position: circleCenter, radius: 4828.03)
        circ.map = googleMapView;
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
    let UOCoordinates = CLLocationCoordinate2D(latitude: 44.0459320, longitude: -123.0706070)

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
                let marker = GMSMarker()
                marker.position = loc.coordinate
                if (self.numberOfPins < 1) {
                    self.pickUpAddress = address
                    marker.title = "Pickup"
                    self.navigationBar.prompt = "Set Dropoff Location"
                }
                else {
                    self.dropOffAddress = address
                    marker.title = "Dropoff"
                    self.navigationBar.prompt = "Press Next to Continue"
                    self.nextButton.enabled = true
                }
                marker.snippet = address
                marker.map = self.googleMapView
                self.googleMapView?.selectedMarker = marker
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
        }
        
        // Add Google Map
        let camera = GMSCameraPosition.cameraWithLatitude((self.UOCoordinates.latitude),
                                                          longitude: (self.UOCoordinates.longitude), zoom: 15)
        googleMapView.camera = camera
        googleMapView!.myLocationEnabled = true
        googleMapView?.settings.myLocationButton = true
        googleMapView?.delegate = self
        
        // Add Google Maps AutoComplete
        resultsViewController = GMSAutocompleteResultsViewController()
        let bounds = GMSCoordinateBounds(coordinate: self.UOCoordinates, coordinate: self.UOCoordinates)
        self.resultsViewController?.autocompleteBounds = bounds
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
        searchController?.hidesNavigationBarDuringPresentation = false
        
        // Add Safe Ride Boundary Area
        let circleCenter = CLLocationCoordinate2D(latitude: UOCoordinates.latitude, longitude: UOCoordinates.longitude)
        let circ = GMSCircle(position: circleCenter, radius: 4828.03)
        circ.map = googleMapView;
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
        
        if let location = locations.last {
            googleMapView!.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            self.userLocation = location
        }
        else {
            print("Could not get user location\n")
        }
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors: " + error.localizedDescription)
    }
    
    // MARK: GMSMapViewDelegate
    func mapView(mapView: GMSMapView, didTapAtCoordinate coordinate: CLLocationCoordinate2D) {
        let location: CLLocation =  CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        addLocation(location)
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

