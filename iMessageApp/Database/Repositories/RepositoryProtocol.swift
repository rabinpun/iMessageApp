//
//  RepositoryProtocol.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import Foundation
import CoreData

protocol Repository {
    associatedtype Object: Identifiable
    func fetch(with predicate: NSPredicate?) -> [Object]
    func create(with entityObject: Object) throws
    func update(predicate: NSPredicate?, with entityObject: Object) throws
    func delete(dbContext: NSManagedObjectContext?,predicate: NSPredicate) throws
    func currentContext() -> NSManagedObjectContext
    func clearRepository()
}

protocol EntityIdentifiable {
    static var entityName: String { get }
}

extension NSManagedObject: EntityIdentifiable {
   public static var entityName: String {
        String(describing: self)
    }
}

protocol NSManagedObjectUpdaterProtocol: Identifiable {
    associatedtype Entity : ObjectCreatorProtocol
    
    @discardableResult
    func updateObject(_ object: Entity, context: NSManagedObjectContext) -> Entity
    
    func createEntity(context: NSManagedObjectContext) -> Entity
}

protocol ObjectCreatorProtocol: NSManagedObject {
    associatedtype Object : NSManagedObjectUpdaterProtocol
    func createObject() -> Object
}
