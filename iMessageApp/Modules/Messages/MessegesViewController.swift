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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }


}

