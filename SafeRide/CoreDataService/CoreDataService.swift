//
//  CoreDataService.swift
//  Address Book
//
//  Created by Caleb Friden on 1/14/16.
//  Copyright © 2016 University of Oregon. All rights reserved.
//

import CoreData
import Foundation


public typealias SaveCompletionHandler = () -> Void


public class CoreDataService {
    public func saveRootContext(completionHandler: SaveCompletionHandler) {
        self.rootContext.performBlock() {
            do {
                try self.rootContext.save()
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completionHandler()
                })
            }
            catch let error {
                fatalError("Failed to save root context: \(error as NSError)")
            }
        }
    }
    
    // MARK: Initialization
    private init() {
        let bundle = NSBundle.mainBundle()
        
        guard let modelPath = bundle.URLForResource(CoreDataService.modelName, withExtension: "momd") else {
            fatalError("Could not find model file with name \"\(CoreDataService.modelName)\", please set CoreDataService.modelName to the name of the model file (without the file extension)")
        }
        
        guard let someManagedObjectModel = NSManagedObjectModel(contentsOfURL: modelPath) else {
            fatalError("Could not load model at URL \(modelPath)")
        }
        
        guard let documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true).first as NSString? else {
            fatalError("Could not find documents directory")
        }
        
        managedObjectModel = someManagedObjectModel
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        let storeRootPath = documentsDirectoryPath.stringByAppendingPathComponent("DataStore") as NSString
        
        let fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(storeRootPath as String) {
            do {
                try fileManager.createDirectoryAtPath(storeRootPath as String, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error {
                fatalError("Error creating data store directory \(error as NSError)")
            }
        }
        
        let persistentStorePath = storeRootPath.stringByAppendingPathComponent("\(CoreDataService.storeName).sqlite")
        let persistentStoreOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        do {
            try persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: NSURL.fileURLWithPath(persistentStorePath), options: persistentStoreOptions)
        }
        catch let error {
            fatalError("Error creating persistent store \(error as NSError)")
        }
        
        rootContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        rootContext.persistentStoreCoordinator = persistentStoreCoordinator
        rootContext.undoManager = nil
        
        mainQueueContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        mainQueueContext.parentContext = rootContext
        mainQueueContext.undoManager = nil
    }
    
    // MARK: Properties
    public let mainQueueContext: NSManagedObjectContext
    
    // MARK: Properties (Private)
    private let managedObjectModel: NSManagedObjectModel
    private let persistentStoreCoordinator: NSPersistentStoreCoordinator
    private let rootContext: NSManagedObjectContext
    
    // MARK: Properties (Static)
    public static var modelName = "Model"
    public static var storeName = "Model"
    public static let sharedCoreDataService = CoreDataService()
}