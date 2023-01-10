//
//  MessagesViewModel.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import Foundation
import CoreData

final class MessagesViewModel: BaseViewModel {
    
    let messagesRepository: CoreDataRepository<Message.Object>
    
    lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        let request = NSFetchRequest<Message>(entityName: Message.entityName)
        let sort = NSSortDescriptor(key: #keyPath(Message.createdAt), ascending: true)
         request.sortDescriptors = [sort]
         request.fetchBatchSize = 20
         request.returnsObjectsAsFaults = false
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: messagesRepository.getMainContext(), sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    init(messagesRepository: CoreDataRepository<Message.Object>) {
        self.messagesRepository = messagesRepository
    }
    
    var messages: [Message] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
}
