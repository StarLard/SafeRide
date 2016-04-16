//
//  User.swift
//  SafeRide
//
//  Created by Zachary Jones on 4/16/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import Foundation
import CoreData
import CoreDataService


class User: NSManagedObject, NamedEntity {
    // MARK: Properties (NamedEntity)
    static var entityName: String {
        return "User"
    }

}
