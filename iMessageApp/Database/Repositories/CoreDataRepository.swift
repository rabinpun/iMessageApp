//
//  CoreDataRepository.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import Foundation
import CoreData

class CoreDataRepository<T: NSManagedObjectUpdaterProtocol>: Repository {
    
    typealias Object = T
    private let inMainContext: Bool
    
    private let database: CoreDataStack
    private let relationEntities: [String]
    
    init(inMainContext: Bool = false, database: CoreDataStack, relationEntities: [String]) {
        self.inMainContext = inMainContext
        self.database = database
        self.relationEntities = relationEntities
    }
    
    private func getContext() -> NSManagedObjectContext {
        inMainContext ? database.mainContext : database.bgContext
    }
    
    func create(with entityObject: T) throws {
        
        let _ = createEntity(from: entityObject)
         try getContext().save()
    }
    
    func findOrCreate(with predicate: NSPredicate) -> NSManagedObject? {
        var entity: T.Entity!
        let context = getContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.Entity.entityName)
        request.predicate = predicate
        if let result = try! context.fetch(request) as? [NSManagedObject], result.count > 0 {
            entity = (result.first! as! T.Entity)
        } else {
            entity = T.Entity(entity:  NSEntityDescription.entity(forEntityName: T.Entity.entityName, in: context)!, insertInto: context)
        }
        return entity
    }
    
    @discardableResult
    private func createEntity(from object: T) -> T.Entity {
        var entity: T.Entity!
        let context = getContext()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.Entity.entityName)
        request.predicate = NSPredicate(format: "id == %@", object.id as! CVarArg)
        
        if let result = try! context.fetch(request) as? [NSManagedObject], result.count > 0 {
            entity = (result.first! as! T.Entity)
            return entity
            } else {
                entity = T.Entity(entity:  NSEntityDescription.entity(forEntityName: T.Entity.entityName, in: context)!, insertInto: context)
            }
        object.updateObject(entity, context: getContext())
        return entity
    }
    
    func update(predicate: NSPredicate? = nil, with entityObject: T) throws {
        var entity: T.Entity!
    
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.Entity.entityName)
        request.returnsObjectsAsFaults = false
        if let predicate = predicate {
            request.predicate = predicate
        }
        let context = getContext()
        
        guard let result = try! context.fetch(request) as? [NSManagedObject], !result.isEmpty else { return }
            entity = (result.first! as! T.Entity)
        _ = entityObject.updateObject(entity, context: context)
         try context.save()
    }
    
    func fetch(with predicate: NSPredicate?) -> T? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.Entity.entityName)
        request.returnsObjectsAsFaults = false
        if let predicate = predicate {
            request.predicate = predicate
        }
        
        let context = getContext()
        let result = try? context.fetch(request) as? [NSManagedObject]
        guard let entity = result?.first as? T.Entity else { return nil }
        return entity.createObject() as? T
    }
    
    func delete(dbContext: NSManagedObjectContext? = nil, predicate: NSPredicate) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.Entity.entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        
        let context = dbContext ?? getContext()
        guard let result = try? context.fetch(request) as? [NSManagedObject] else { return }
        result.forEach { entity in
            context.delete(entity)
        }
        try context.save()
    }
   
    func clearRepository() {
        var entities = [String]()
        entities.append(T.Entity.entityName)
        let context = getContext()
        context.performAndWait {
            do {
                try entities.forEach { (entityName) in
                    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
                    let request = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                    try context.execute(request)
                }
                try context.save()
            } catch {
                assertionFailure("Cannot perform delete \(error)")
            }
        }
    }
    
    func currentContext() -> NSManagedObjectContext {
        getContext()
    }
    
    func getMainContext() -> NSManagedObjectContext {
        database.mainContext
    }
}

