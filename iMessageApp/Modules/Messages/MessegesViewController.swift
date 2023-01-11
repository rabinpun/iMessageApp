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
        scrollToLast()
    }
    
    private func scrollToLast() {
        let lastIndex = viewModel.messages.count
        screenView.collectionView.scrollToItem(at: IndexPath(row: lastIndex, section: 0), at: .bottom, animated: true)
    }
    
    var currentSelectedIndexPath: IndexPath?
    
    override func setupUI() {
        screenView.collectionView.delegate = self
        screenView.collectionView.dataSource = self
        
        viewModel.fetchedResultsController.delegate = self
        try! viewModel.fetchedResultsController.performFetch()
        
    }
    
    override func observeEvents() {
    }
    
    func bindTextModelTo(textField: UITextField) {
        viewModel.messageTextModel.bind(textField.binder())
        textField.keyboardToolbar.doneBarButton.setTarget(self, action: #selector(doneButtonClicked))
    }
    
    @objc func doneButtonClicked(_ sender: Any) {
        
        let text = viewModel.messageTextModel.value
        guard !text.isEmpty else {
            alert(title: "iMessage", msg: "Message should not be empty.", actions: [Alert.ok]).sink { _ in
                
            }.store(in: &viewModel.bag)
            return }
        viewModel.messageTextModel.value = ""
        guard let currentSelectedIndexPath = currentSelectedIndexPath else { return }
        let isLast = currentSelectedIndexPath.row == viewModel.messages.count
        if !isLast {
            let message = viewModel.messages[currentSelectedIndexPath.row].createObject()
            viewModel.updateMessage(message: message, text)
        } else {
            viewModel.addMessage(text)
        }
        self.currentSelectedIndexPath = nil
        screenView.endEditing(true)
        screenView.collectionView.deselectItem(at: currentSelectedIndexPath, animated: true)
        if isLast {
            scrollToLast()
        } else {
            screenView.collectionView.scrollToItem(at: currentSelectedIndexPath, at: .centeredVertically, animated: true)
        }
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
                screenView.collectionView.reloadItems(at: [newIndexPath])
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

