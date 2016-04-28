//
//  Ride.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/27/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import Foundation
import CoreData
import CoreDataService


class Ride: NSManagedObject, NamedEntity {
    
    // MARK: Properties (NamedEntity)
    static var entityName: String {
        return "Ride"
    }
}
