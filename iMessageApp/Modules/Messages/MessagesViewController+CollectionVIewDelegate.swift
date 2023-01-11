//
//  MessagesViewController+CollectionVIewDelegate.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import UIKit
import UIBinding

extension MessegesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var message = ""
        if indexPath.row < viewModel.messages.count {
            message = viewModel.messages[indexPath.row].message
        } else {
            message = "Click to add message...."
        }
        return CGSize(width: collectionView.bounds.width, height: message.height(withConstrainedWidth: collectionView.bounds.width, font: .systemFont(ofSize: 14)) + 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let messageCell = collectionView.cellForItem(at: indexPath) as? MessageCell else { return }
        let isLastMessage = indexPath.row == viewModel.messages.count
        currentIndexPath = indexPath
        let messageTextModel = UIControlBinding<UITextField, String>()
        viewModel.messageTextModel = messageTextModel
        messageTextModel.bind(messageCell.textField.binder())
        messageTextModel.value = isLastMessage ? "" : messageCell.label.text ?? ""
        messageTextModel.dropFirst().sink { value in
            guard let currentIndexPath = self.currentIndexPath else { return }
            guard let cell = self.screenView.collectionView.cellForItem(at: currentIndexPath) as? MessageCell else { return }
            cell.label.text = value
        }.store(in: &viewModel.bag)
        messageCell.textField.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked), titleText: "Done")
        messageCell.textField.becomeFirstResponder()
    }
    
}
