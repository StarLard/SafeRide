//
//  SettingsService.swift
//  SafeRide
//
//  Created by Caleb Friden on 4/16/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import CoreData
import CoreDataService
import Foundation

class SettingsService {
    // MARK: Service
    func user() -> NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(namedEntity: User.self)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        return NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    // MARK: Initialization
    private init() {
        
        let context = CoreDataService.sharedCoreDataService.mainQueueContext
        context.performBlockAndWait {
            let fetchRequest = NSFetchRequest(namedEntity: User.self)
            if context.countForFetchRequest(fetchRequest, error: nil) == 0 {
                
                var user = NSEntityDescription.insertNewObjectForNamedEntity(Food.self, inManagedObjectContext: context)
                user.firstName = ""
                user.lastName = ""
                user.phoneNumber = ""
                user.uoid = ""
                user.home = ""
                
                try! context.save()
                CoreDataService.sharedCoreDataService.saveRootContext {
                    print("Successfully saved user data")
                }
            }
        }
    }
    
    // MARK: Properties (Static)
    static let sharedSettingsService = SettingsService()
}