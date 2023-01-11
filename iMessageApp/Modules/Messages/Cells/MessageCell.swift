//
//  MessageCell.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit

final class ExtensionMessageCell: MessageCell {
    
    override var actionButtonImage: UIImage? {
        UIImage(systemName: "checkmark")
    }

    override var actionButtonTintColor: UIColor {
        .systemGreen
    }
    
    override var isSelected: Bool {
        didSet {
            wrapperView.backgroundColor = isSelected ? .white : .systemGreen
            buttonWidthConstraint.constant = isSelected ? 20 : 0
        }
    }
    
}

class MessageCell: UICollectionViewCell {
    
        lazy var wrapperView: UIView = {
            let view = UIView()
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.5).cgColor
            view.backgroundColor = .systemGreen
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
            view.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        lazy var label: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = UIColor.white
            label.textAlignment = .left
            label.numberOfLines = 0
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
    
        lazy var expanderView: UIView = {
            let view = UIView()
            view.setContentHuggingPriority(.defaultLow, for: .horizontal)
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
    
        lazy var textField: UITextField = {
            let textField = UITextField()
            textField.tintColor = .clear
            textField.textColor = .clear
            textField.isHidden = true
            return textField
        }()
    
        var actionButtonImage: UIImage? {
            UIImage(systemName: "multiply")
        }
    
        var actionButtonTintColor: UIColor {
            .systemRed
        }
    
        lazy var deleteButton: UIButton = {
            let button = UIButton()
            button.setImage(actionButtonImage, for: .normal)
            button.tintColor = actionButtonTintColor
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
    
        var canBeDeleted = true
    
        override var isSelected: Bool {
            didSet {
                wrapperView.backgroundColor = isSelected ? .white : .systemGreen
                label.textColor = isSelected ? .lightGray : .white
                if canBeDeleted {
                    buttonWidthConstraint.constant = isSelected ? 20 : 0
                } else {
                    buttonWidthConstraint.constant = 0
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        override func prepareForReuse() {
            super.prepareForReuse()
            label.text = ""
            canBeDeleted = true
            isUserInteractionEnabled = true
        }
        
        private func setup() {
            addSubviews()
        }
    
        var buttonWidthConstraint: NSLayoutConstraint!
        
        func addSubviews() {
            contentView.addSubview(wrapperView)
            wrapperView.addSubview(label)
            wrapperView.addSubview(deleteButton)
            contentView.addSubview(textField)
            contentView.addSubview(expanderView)
            
            buttonWidthConstraint = deleteButton.widthAnchor.constraint(equalToConstant: 0)
            
            NSLayoutConstraint.activate([
                wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                wrapperView.trailingAnchor.constraint(equalTo: expanderView.leadingAnchor),
                wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
                wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                deleteButton.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 5),
                deleteButton.trailingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -5),
                deleteButton.topAnchor.constraint(equalTo: label.topAnchor),
                deleteButton.bottomAnchor.constraint(equalTo: label.bottomAnchor),
                buttonWidthConstraint,
    
                expanderView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                expanderView.topAnchor.constraint(equalTo: contentView.topAnchor),
                expanderView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                label.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 5),
                label.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 5),
                label.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -5),
            ])
        }
        
    func configure(title: String, isLastMessage: Bool = false) {
        label.text = title
        canBeDeleted = !isLastMessage
        wrapperView.backgroundColor = isLastMessage ? .systemBlue : .systemGreen
    }
    
}

