//
//  MessagesController+Datasource.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import UIKit

extension MessegesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let message = viewModel.messages[indexPath.row]
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.identifier, for: indexPath) as? MessageCell else { fatalError("Invalid Cell") }
        cell.configure(title: message)
        return cell
    }
    
}
