//
//  GoogleMapsAutocomplete.swift
//  SafeRide
//
//  Created by Caleb Friden on 5/11/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps

// Handle the user's selection.
extension MapViewController: GMSAutocompleteResultsViewControllerDelegate {
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didAutocompleteWithPlace place: GMSPlace) {
        searchController?.active = false
        
        // Do something with the selected place.
        
        if numberOfPins < 2 {
            let geocoder = CLGeocoder()
            if let destination = place.formattedAddress {
                geocoder.geocodeAddressString(destination, completionHandler: {(placemarks, error) -> Void in
                    if((error) != nil){
                        print("Error occured while geocoding address: \"" + destination + "\", error: ", error)
                    }
                    if let clDropoffPlacemark = placemarks?.first {
                        if let coordinate = clDropoffPlacemark.location?.coordinate {
                            // Drop a pin
                            let marker = GMSMarker()
                            marker.position = coordinate
                            if (self.numberOfPins < 1)  {
                                marker.title = "Pickup"
                                self.pickUpAddress = destination
                                self.navigationBar.prompt = "Set Dropoff Location"
                            }
                            else {
                                marker.title = "Dropoff"
                                self.dropOffAddress = destination
                                self.nextButton.enabled = true
                                self.navigationBar.prompt = "Press Next to Continue"
                            }
                            marker.snippet = place.name
                            marker.map = self.googleMapView
                            self.googleMapView?.selectedMarker = marker
                            self.numberOfPins += 1
                        }
                        else {
                            print("Error: Could not unwrap placemark.location\n")
                        }
                    }
                    else {
                        print("Error: Could not unwrap placemarks\n")
                    }
                })
            }
            else {
                print("Error: Destination Address could not be unwrapped\n")
            }
        }

    }
    
    func resultsController(resultsController: GMSAutocompleteResultsViewController,
                           didFailAutocompleteWithError error: NSError){
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictionsForResultsController(resultsController: GMSAutocompleteResultsViewController) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}