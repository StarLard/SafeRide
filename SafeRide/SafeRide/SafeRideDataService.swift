//
//  SettingsService.swift
//  SafeRide
//
//  Created by Caleb Friden on 4/16/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import CoreData
import CoreDataService
import SwiftDDP
import Foundation

class SafeRideDataService {
    // MARK: Core Data Service
    func user() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(namedEntity: User.self)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "firstName", ascending: true)]
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    func rides() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(namedEntity: Ride.self)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // MARK: Meteor Service
    
    func loadRidesFromMeteor() -> Void {
        Meteor.client.allowSelfSignedSSL = false     // Connect to a server that uses a self signed ssl certificate
        Meteor.client.logLevel = .Debug
        
        
        dispatch_async(dispatch_get_main_queue(), {
            Meteor.connect("wss://saferide.meteorapp.com/websocket") {
                Meteor.call("Scheduled.find().fetch()", params: [], callback: {result, error in
                })
            }
        })
    }
    
    func insertPending(name: String, universityID uoid: String, phoneNumber phone: String, pickupAddress pickup: String, dropoffAddress dropoff: String, numberofRiders numOfRiders: String, timeOfRide rideTime: String) {
        // Meteor Stuff
        Meteor.client.allowSelfSignedSSL = false     // Connect to a server that uses a self signed ssl certificate
        Meteor.client.logLevel = .None

        
        dispatch_async(dispatch_get_main_queue(), {
            Meteor.connect("wss://saferide.meteorapp.com/websocket") {
                Meteor.call("insertPending", params: [name, uoid, phone, pickup, dropoff, numOfRiders, rideTime], callback: {result, error in
                })
            }
        })
    }
    
    // MARK: Initialization
    private init() {
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        context.performBlockAndWait {
            let fetchRequest = NSFetchRequest(namedEntity: User.self)
            if context.countForFetchRequest(fetchRequest, error: nil) == 0 {
                
                let user = NSEntityDescription.insertNewObjectForNamedEntity(User.self, inManagedObjectContext: context)
                user.firstName = ""
                user.lastName = ""
                user.phoneNumber = ""
                user.uoid = ""
                //user.home = ""
                
                try! context.save()
                CoreDataService.sharedCoreDataService.saveRootContext {
                    print("Successfully saved user data")
                }
            }
        }
    }
    
    // MARK: Properties (Static)
    static let sharedSafeRideDataService = SafeRideDataService()
}