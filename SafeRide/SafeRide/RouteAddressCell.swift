//
//  RouteAddressCell.swift
//  SafeRide
//
//  Created by Advancement IT Student on 5/11/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit
import MapKit

class RouteAddressCell: UITableViewCell {

    // MARK: Properties (IBOutlet)
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressField: UITextView!
    
    // MARK: Properties (IBAction)
    
    @IBAction func routeButtonPressed(sender: UIButton) {
        
        let geocoder = CLGeocoder()
        
        if let destination = self.addressField.text {
            geocoder.geocodeAddressString(destination, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil){
                    print("Error", error)
                }
                if let clDropoffPlacemark = placemarks?.first {
                    if let addressDict = clDropoffPlacemark.addressDictionary as! [String:AnyObject]?, coordinate = clDropoffPlacemark.location?.coordinate {
                        let mapItem = MKMapItem(placemark:MKPlacemark(coordinate: coordinate, addressDictionary: addressDict))
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        mapItem.openInMapsWithLaunchOptions(launchOptions)
                    }
                }
            })
        }
    }

}
