//
//  BaseView.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit

class BaseView: UIView {
    
    /// The freeze view
    private lazy var freezerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    /// Frame Initializer
    override public init(frame: CGRect) {
        super.init(frame: frame)
        create()
    }
    
    /// Coder initializer
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        create()
    }
    
    /// base function to create the subviews
    /// This function is override by different views to create their own subviews
    open func create() {
        self.backgroundColor = .white
    }
}
