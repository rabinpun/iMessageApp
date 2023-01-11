//
//  MessagesViewController+DataSource.swift
//  iMessageExtension
//
//  Created by ebpearls on 11/01/2023.
//

import UIKit

extension MessagesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = messages[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExtensionMessageCell.identifier, for: indexPath) as? MessageCell else { fatalError("Invalid Cell") }
        cell.configure(title: message.message)
        return cell
    }
    

}
