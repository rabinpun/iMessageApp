//
//  MessagesViewController+CollectionVIewDelegate.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import UIKit

extension MessegesViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = viewModel.messages[indexPath.row]
        return CGSize(width: collectionView.bounds.width, height: message.height(withConstrainedWidth: collectionView.bounds.width, font: .systemFont(ofSize: 14)) + 10)
    }
    
}
