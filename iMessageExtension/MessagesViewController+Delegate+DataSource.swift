//
//  MessagesViewController+Delegate.swift
//  iMessageExtension
//
//  Created by ebpearls on 11/01/2023.
//

import UIKit
import UIBinding
import Messages

extension MessagesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = messages[indexPath.row].message
        return CGSize(width: collectionView.bounds.width, height: message.height(withConstrainedWidth: collectionView.bounds.width, font: .systemFont(ofSize: 14)) + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let messageCell = collectionView.cellForItem(at: indexPath) as? MessageCell else { return }
        currentSelectedIndexPath = indexPath
        
        //Select functionality
        let selectionButtonModel = UIControlBinding<UIButton, Bool>()
        selectionButtonModel.bind(messageCell.deleteButton.binder())
        self.selectionButtonModel = selectionButtonModel
        anyCancellable = selectionButtonModel.dropFirst().sink { [weak self] _ in
            self?.showDeleteAlert()
        }
    }

    private func showDeleteAlert() {
        guard let currentIndexPath = self.currentSelectedIndexPath else { return }
        print(messages[currentIndexPath.row])
        
        
        let layout = MSMessageTemplateLayout()
        layout.caption = ""
        layout.subcaption =  messages[currentIndexPath.row].message

        let session = MSSession()
        let message = MSMessage(session: session)
        message.layout = layout

        self.activeConversation?.insert(message, completionHandler: nil)
    }
    
}
