//
//  BaseController.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit
import Combine

/// The parent of all controller inside app
class BaseController: UIViewController {
    
    /// The baseView of controller
    private(set) var baseView: BaseView!
    
    /// The baseViewModel of controller
    private(set) var baseViewModel: BaseViewModel!
    
    /// when view is loaded
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        /// setup UI
        setupUI()
        
        /// observe events
        observeEvents()
    }
    
    /// Method that will set the viewmodel after initialization from storyboard
    /// - Parameter viewModel: the viewmodel for the controller
    func setViewModel(viewModel: BaseViewModel) {
        guard baseViewModel == nil else { return }
        baseViewModel = viewModel
    }
    
    /// Initializer for a controller
    /// - Parameters:
    ///   - baseView: the view associated with the controller
    ///   - baseViewModel: viewModel associated with the controller
    public init(baseView: BaseView, baseViewModel: BaseViewModel) {
        self.baseView = baseView
        self.baseViewModel = baseViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Load the base view as the view of controller
    override open func loadView() {
        super.loadView()
        view = baseView
    }
    
    /// setup triggers
    open func setupUI() {}
    
    open func observeEvents() {}
}

extension BaseController {
    
    /// Method to present alert with actions provided
    /// - Parameters:
    ///   - title: the title of alert
    ///   - msg: the message of alert
    ///   - actions: the actions to display
    func alert(title: String, msg: String, actions: [AlertActionable]) -> AnyPublisher<AlertActionable, Never> {
        
        Future<AlertActionable, Never> { [weak self] promise in
            guard let self = self else { return }
            let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
            actions.forEach { action in
                let alertAction = UIAlertAction(title: action.title, style: action.destructive ? .destructive: .default) { _ in
                    promise(.success(action))
                }
                alert.addAction(alertAction)
            }
            self.present(alert, animated: true, completion: nil)
        }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
    }

}
