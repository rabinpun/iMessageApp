//
//  MessagesViewModel.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit
import CoreData
import UIBinding

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
    
    var messages: [Message] {
        fetchedResultsController.fetchedObjects ?? []
    }
    
    let messageTextModel = UIControlBinding<UITextField, String>()
    
    init(messagesRepository: CoreDataRepository<Message.Object>) {
        self.messagesRepository = messagesRepository
    }
    
    func addMessage(_ text: String) {
        do {
            try messagesRepository.create(with: Message.Object(id: UUID().uuidString, message: text, createdAt: Date()))
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}
