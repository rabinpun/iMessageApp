//
//  MessagesController+Datasource.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import UIKit

extension MessegesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.messages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard indexPath.row < viewModel.messages.count else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else { fatalError("Invalid Cell") }
            cell.configure(title: "Click to add message....", isLastMessage: true)
            return cell
        }
        let message = viewModel.messages[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else { fatalError("Invalid Cell") }
        cell.configure(title: message.message)
        return cell
    }
    
}
