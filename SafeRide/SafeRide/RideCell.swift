//
//  RideCell.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/27/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import UIKit

class RideCell: UITableViewCell {

    // MARK: Properties (IBOutlet)
    
    var ride: Ride?
    
    @IBOutlet weak var rideTimeLabel: UILabel!
    @IBOutlet weak var riderNameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!

}
