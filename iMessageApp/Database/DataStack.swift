//
//  DataStack.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import CoreData
import Foundation

public protocol CoreDataStack {
    
    /// Intializer for CoreDataStack with given model file name
    ///
    /// - Parameter modelFileName: the fileName to use
    init(modelName: String, storeType: String)
    
    /// The main context
    var mainContext: NSManagedObjectContext { get set }
    
    /// The background context
    var bgContext: NSManagedObjectContext { get set }
    
    /// The persistent container
    var persistentContainer: NSPersistentContainer { get set }
    
    //laodDatabase
    func setup(completion: @escaping () -> Void)
}

/// DataStack class
final class AppDataStack: CoreDataStack {
    
    // MARK: - Properties
    private let bundle: Bundle
    private let modelName: String
    private let storeType: String
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: modelName, managedObjectModel: managedObjectModel)
        container.persistentStoreDescriptions = [storeDescription]
        return container
    }()
    
    // MARK: Initializers
    init(modelName: String = Constant.Database.modelName, storeType: String = NSSQLiteStoreType) {
        self.bundle = Bundle(for: AppDataStack.self)
        self.modelName = modelName
        self.storeType = NSSQLiteStoreType
    }
    
    public func setup(completion: @escaping () -> Void) {
        loadPersistentStore {
            completion()
        }
    }
    
    // MARK: Main context
    final lazy var mainContext: NSManagedObjectContext = {
        let mainContext = self.persistentContainer.viewContext
        self.setConfigTo(context: mainContext)
        mainContext.automaticallyMergesChangesFromParent = true
        return mainContext
    }()
    
    // MARK: Background context
    final lazy var bgContext: NSManagedObjectContext = {
        let backgroundContext = self.persistentContainer.newBackgroundContext()
        setConfigTo(context: backgroundContext)
        return backgroundContext
    }()
    
    // MARK: Set configuration to context
    private func setConfigTo(context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.shouldDeleteInaccessibleFaults = true
    }
    
    // MARK: Persistent store coordinator
    final lazy var storeCoordinator: NSPersistentStoreCoordinator = {
        return persistentContainer.persistentStoreCoordinator
    }()
    
    final lazy var managedObjectModel: NSManagedObjectModel = {
        guard let modelUrl = bundle.url(forResource: modelName, withExtension: "momd") else {
            fatalError("could not find managed object model in bundle")
        }
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    
    // MARK: Store description
     fileprivate lazy var storeDescription: NSPersistentStoreDescription = {
        let storeDescription = NSPersistentStoreDescription(url: storeFullURL)
        debugPrint("SQLITE FILE: ", storeFullURL)
        storeDescription.type = storeType
        storeDescription.shouldInferMappingModelAutomatically = true
        storeDescription.shouldMigrateStoreAutomatically = true
        return storeDescription
    }()
    
    // MARK: Store URL
    private lazy var storeFullURL: URL = {
        return URL.storeURL(for: Constant.appGroup, databaseName: modelName)
    }()
    
    // MARK: Save Context that has changes
    final func saveContext() {
        
        mainContext.performAndWait {
            if mainContext.hasChanges {
                do {
                    try mainContext.save()
                } catch {
                    debugPrint("Failed to save background context : \(error)")
                }
                
            }
        }
        
        bgContext.performAndWait {
            if bgContext.hasChanges {
                do {
                    try bgContext.save()
                } catch {
                    debugPrint("Failed to save background context : \(error)")
                }
                
            }
        }
        
    }
    
}

extension AppDataStack {
    
    private func loadPersistentStore(completion: @escaping () -> Void) {
        self.persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError("was unable to load store \(error!)")
            }
            completion()
        }
    }
    
}
