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
        currentSelectedIndexPath = indexPath
        
        //text update functionality
        let messageTextModel = UIControlBinding<UITextField, String>()
        viewModel.messageTextModel = messageTextModel
        messageTextModel.bind(messageCell.textField.binder())
        messageTextModel.value = isLastMessage ? "" : messageCell.label.text ?? ""
        messageTextModel.dropFirst().sink { [weak self] value in
            self?.updateSelectedCellText(value)
        }.store(in: &viewModel.bag)
        
        //Delete functionality
        let deleteButtonModel = UIControlBinding<UIButton, Bool>()
        deleteButtonModel.bind(messageCell.deleteButton.binder())
        viewModel.deleteTextModel = deleteButtonModel
        deleteButtonModel.dropFirst().sink { [weak self] _ in
            self?.showDeleteAlert()
        }.store(in: &viewModel.bag)
        
        //Update delete functionality
        messageCell.textField.addDoneOnKeyboardWithTarget(self, action: #selector(doneButtonClicked), titleText: "Done")
        messageCell.textField.becomeFirstResponder()
    }
    
    private func updateSelectedCellText(_ text: String) {
        guard let currentIndexPath = currentSelectedIndexPath else { return }
        guard let cell = screenView.collectionView.cellForItem(at: currentIndexPath) as? MessageCell else { return }
        cell.label.text = text
    }
    
    private func showDeleteAlert() {
        alert(title: "iMessage", msg: "Are you sure you want to delete this message ?", actions: [Alert.delete, Alert.cancel]).sink { [weak self] alertAction in
            guard let self = self else { return }
            switch alertAction {
                case Alert.delete:
                    guard let currentIndexPath = self.currentSelectedIndexPath else { return }
                    self.view.endEditing(true)
                    self.viewModel.deleteMessage(id: self.viewModel.messages[currentIndexPath.row].id)
                default:
                    break
            }
        }.store(in: &viewModel.bag)
    }
    
}
