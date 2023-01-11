//
//  MessagesView.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit

final class CustomTextField: UITextField {
    
    var leftViewSize = CGSize(width: 20, height: 20)
    var rightViewSize = CGSize.zero
    var leftPadding: CGFloat = 15
    var rightPadding: CGFloat = 0
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let width = (bounds.width - (leftPadding * 2) - leftViewSize.width - (rightPadding * 2) - rightViewSize.width)
        return CGRect(origin: .init(x: (leftPadding * 2) + leftViewSize.width, y: 0 ), size: CGSize(width: width, height: bounds.height))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let width = (bounds.width - (leftPadding * 2) - leftViewSize.width - (rightPadding * 2) - rightViewSize.width)
        return CGRect(origin: .init(x: (leftPadding * 2) + leftViewSize.width, y: 0), size: CGSize(width: width, height: bounds.height))
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let originalTextRect = super.leftViewRect(forBounds: bounds)
        return CGRect(origin: .init(x: originalTextRect.origin.x + leftPadding, y: originalTextRect.origin.y), size: leftViewSize)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let originalTextRect = super.rightViewRect(forBounds: bounds)
        return CGRect(origin: .init(x: originalTextRect.origin.x - rightPadding - rightViewSize.width * 0.5, y: originalTextRect.origin.y), size: rightViewSize)
    }
    
}

final class MessagesView: BaseView {
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func create() {
        backgroundColor = .white
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
}
