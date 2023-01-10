//
//  MessegesViewController.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit

class MessegesViewController: BaseController {

    lazy var screenView: MessagesView = { baseView as! MessagesView }()
    
    lazy var viewModel: MessagesViewModel = { baseViewModel as! MessagesViewModel }()
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            let lastIndex = self.viewModel.messages.count - 1
            self.screenView.collectionView.scrollToItem(at: IndexPath(row: lastIndex, section: 0), at: .bottom, animated: true)
        }
    }
    
    override func setupUI() {
        screenView.collectionView.delegate = self
        screenView.collectionView.dataSource = self
    }


}

