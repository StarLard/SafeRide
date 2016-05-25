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
    
    private func wipeRides(completionHandler: (success:Bool) -> Void) {
        let resultsController = self.rides()
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        do {
            try resultsController.performFetch()
            try resultsController.performFetch()
            
            let sections = resultsController.sections?.count ?? 0
            for i in 0 ..< sections {
                let rows = resultsController.sections![i].numberOfObjects
                for j in 0 ..< rows {
                    let indexPath = NSIndexPath(forRow: j, inSection: i)
                    let ride = resultsController.objectAtIndexPath(indexPath) as! Ride
                    context.deleteObject(ride)
                }
            }
            try! context.save()
            CoreDataService.sharedCoreDataService.saveRootContext {
                print("Successfully wiped rides data")
                completionHandler(success: true)
            }

        }
        catch {
            print("Error: could not fetch rides")
            completionHandler(success: false)
            return
        }
    }
    
    // MARK: Meteor Service
    
    func loadRidesFromMeteor(username: String, pass password: String, completionHandler: (success:Bool) -> Void) {
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        
        // Wipe outdated rides from device
        
        self.wipeRides(){ success in
            if success {
                
                // Get rides from server
                
                
                context.performBlockAndWait {
                    Meteor.loginWithUsername(username, password: password) { result, error in
                        if (error == nil) {
                            Meteor.call("getScheduled", params: [], callback: {result, error in
                                if let rides = result {
                                    let numberOfRides = rides.count
                                    for i in 0 ..< numberOfRides {
                                        guard let meteorID = rides[i]["_id"],
                                            let dropoff = rides[i]["dropoff"],
                                            let name = rides[i]["name"],
                                            let phone = rides[i]["phone"],
                                            let time = rides[i]["pickupTime"],
                                            let pickup = rides[i]["pickup"],
                                            let numberOfRiders = rides[i]["riders"],
                                            let uoid = rides[i]["uoid"] else {
                                                print("Error: Unable to get unwrap ride info.\n")
                                                return
                                        }
                                        let ride = NSEntityDescription.insertNewObjectForNamedEntity(Ride.self, inManagedObjectContext: context)
                                        
                                        ride.meteorID = meteorID as? String
                                        ride.dropoff = dropoff as? String
                                        ride.rider = name as? String
                                        ride.phone = phone as? String
                                        ride.time = time as? String
                                        ride.pickup = pickup as? String
                                        ride.numberOfRiders = numberOfRiders as? String
                                        ride.uoid = uoid as? String
                                        
                                    }
                                    
                                    try! context.save()
                                    CoreDataService.sharedCoreDataService.saveRootContext {
                                        print("Successfully saved rides data")
                                        completionHandler(success: true)
                                    }
                                }
                                else {
                                    if let reason = error?.reason {
                                        print(reason)
                                    }
                                    completionHandler(success: false)
                                    return
                                }
                            })
                        }
                        else {
                            if let reason = error?.reason {
                                print(reason)
                            }
                            print("username: " + username)
                            print("password: " + password)
                            completionHandler(success: false)
                            return
                        }
                    }
                }
                
            }
            else {
                print("Error: could not wipe data")
            }
            
        }
    }
    
    func insertPending(name: String, universityID uoid: String, phoneNumber phone: String, pickupAddress pickup: String, dropoffAddress dropoff: String, numberofRiders numOfRiders: String, timeOfRide rideTime: String, completionHandler: (success:Bool) -> Void) {
        Meteor.call("insertPending", params: [name, uoid, phone, pickup, dropoff, numOfRiders, rideTime], callback: {result, error in
            if (error == nil) {
                completionHandler(success: true)
            }
            else {
                if let reason = error?.reason {
                    print(reason)
                }
                completionHandler(success: false)
            }
        })
    }
    
    func removeSheduled(meteorID: String, completionHandler: (success:Bool) -> Void) {
        Meteor.call("removeScheduled", params: [meteorID], callback: {result, error in
            if (error == nil) {
                completionHandler(success: true)
            }
            else {
                if let reason = error?.reason {
                    print(reason)
                }
                completionHandler(success: false)
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