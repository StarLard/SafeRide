//
//  Ride+CoreDataProperties.swift
//  SafeRide
//
//  Created by Advancement IT Student on 4/27/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Ride {

    @NSManaged var rider: String?
    @NSManaged var pickup: String?
    @NSManaged var dropoff: String?
    @NSManaged var time: String?
    @NSManaged var uoid: String?
    @NSManaged var phone: String?
    @NSManaged var numberOfRiders: String?
    @NSManaged var meteorID: String?

}
