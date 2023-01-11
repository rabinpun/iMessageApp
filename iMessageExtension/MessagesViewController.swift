//
//  MessagesViewController.swift
//  iMessageExtension
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit
import UIBinding
import Messages
import Combine

class MessagesViewController: MSMessagesAppViewController {
    
    let dataStack = AppDataStack()
    lazy var repo = CoreDataRepository<Message.Object>.init(inMainContext: true, database: dataStack, relationEntities: [Message.entityName])
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(ExtensionMessageCell.self, forCellWithReuseIdentifier: ExtensionMessageCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    var currentSelectedIndexPath: IndexPath?
    
    var selectionButtonModel = UIControlBinding<UIButton, Bool>()
    
    var messages = [Message.Object]()
    
    var anyCancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        dataStack.setup {
            self.messages = self.repo.fetch(with: nil)
            self.collectionView.delegate = self
            self.collectionView.dataSource = self
        }
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        guard let currentIndexPath = self.currentSelectedIndexPath else { return }
        self.currentSelectedIndexPath = nil
        collectionView.deselectItem(at: currentIndexPath, animated: true)
    }

}
