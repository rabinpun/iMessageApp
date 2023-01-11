//
//  MessageViewController+NSFetchResultsControllerDelegate.swift
//  iMessageApp
//
//  Created by ebpearls on 11/01/2023.
//

import Foundation
import CoreData

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

