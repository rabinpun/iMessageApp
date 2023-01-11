//
//  MessegesViewController.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit
import CoreData
import UIBinding

class MessegesViewController: BaseController {

    lazy var screenView: MessagesView = { baseView as! MessagesView }()
    
    lazy var viewModel: MessagesViewModel = { baseViewModel as! MessagesViewModel }()
    
    override func viewDidAppear(_ animated: Bool) {
        let lastIndex = self.viewModel.messages.count - 1
        self.screenView.collectionView.scrollToItem(at: IndexPath(row: lastIndex, section: 0), at: .bottom, animated: true)
    }
    
    override func setupUI() {
        screenView.collectionView.delegate = self
        screenView.collectionView.dataSource = self
        
        viewModel.fetchedResultsController.delegate = self
        try! viewModel.fetchedResultsController.performFetch()
        
        viewModel.messageTextModel.bind(screenView.textField.binder())
        screenView.textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
    
    override func observeEvents() {
        viewModel.messageTextModel.sink { value in
            print(value)
        }.store(in: &viewModel.bag)
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        let text = viewModel.messageTextModel.value
        viewModel.messageTextModel.value = ""
        viewModel.addMessage(text)
    }


}

//MARK: NSFetchedResultsController Delegate Functions
extension MessegesViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        debugPrint("content changed")
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
            switch type {
            case .insert:
                guard let newIndexPath = newIndexPath else { fatalError("Index path should be not nil") }
                screenView.collectionView.insertItems(at: [newIndexPath])
            case .update:
                guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
                screenView.collectionView.reloadItems(at: [indexPath])
            case .move:
                break
            case .delete:
                guard let indexPath = indexPath else { fatalError("Index path should be not nil") }
                screenView.collectionView.deleteItems(at: [indexPath])
            @unknown default: break
            }
    }
}

