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
    
    var messageTextModel = UIControlBinding<UITextField, String>()
    var deleteTextModel = UIControlBinding<UIButton, Bool>()
    
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
    
    func updateMessage(message: Message.Object,_ text: String) {
        do {
            let messagePredicate = NSPredicate(format: "%K == %@", #keyPath(Message.id) , message.id)
            try messagesRepository.update(predicate: messagePredicate, with: Message.Object(id: message.id, message: text, createdAt: message.createdAt))
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func deleteMessage(id: String) {
        do {
            let messagePredicate = NSPredicate(format: "%K == %@", #keyPath(Message.id) , id)
            try messagesRepository.delete(predicate: messagePredicate)
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
}
