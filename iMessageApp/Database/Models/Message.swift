//
//  Message.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import Foundation
import CoreData

@objc(Message)
class Message : NSManagedObject {
    @NSManaged var id: String
    @NSManaged var message: String
    @NSManaged var createdAt: Date
}

extension Message {
    
    struct Object: NSManagedObjectUpdaterProtocol {
        
        typealias Entity = Message
        
        var id: String
        let message: String
        let createdAt: Date
        
        @discardableResult
        func updateObject(_ object: Entity, context: NSManagedObjectContext) -> Entity {
            object.id = id
            object.message = message
            object.createdAt = createdAt
            return object
        }
        
        func createEntity(context: NSManagedObjectContext) -> Entity {
            let entity = Entity(context: context)
            entity.id = id
            entity.message = message
            entity.createdAt = createdAt
            return entity
        }
        
    }
    
}

extension Message: ObjectCreatorProtocol {
    func createObject() -> Object {
        Object(id: id, message: message, createdAt: createdAt)
    }
}
