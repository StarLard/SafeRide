//
//  User+CoreDataProperties.swift
//  SafeRide
//
//  Created by Zachary Jones on 4/16/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension User {

    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var phoneNumber: String?
    @NSManaged var uoid: String?

}
