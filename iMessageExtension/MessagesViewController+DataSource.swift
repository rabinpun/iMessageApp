//
//  MessagesViewController+DataSource.swift
//  iMessageExtension
//
//  Created by ebpearls on 11/01/2023.
//

import UIKit

extension MessagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.isEmpty ? 1 : messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages.isEmpty ? "No saved messages." : messages[indexPath.row].message
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExtensionMessageCell.identifier, for: indexPath) as? MessageCell else { fatalError("Invalid Cell") }
        if messages.isEmpty {
            cell.isUserInteractionEnabled = false
        }
        cell.configure(title: message)
        return cell
    }
    

}
