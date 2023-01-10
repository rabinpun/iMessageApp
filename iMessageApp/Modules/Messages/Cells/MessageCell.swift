//
//  MessageCell.swift
//  iMessageApp
//
//  Created by ebpearls on 09/01/2023.
//

import UIKit

final class MessageCell: UICollectionViewCell {
    
        var wrapperView: UIView = {
            let view = UIView()
            view.layer.borderWidth = 1.0
            view.layer.borderColor = UIColor.systemGreen.withAlphaComponent(0.5).cgColor
            view.backgroundColor = .systemGreen
            view.clipsToBounds = true
            view.layer.cornerRadius = 10
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        var label: UILabel = {
            let label = UILabel()
            label.font = .systemFont(ofSize: 14)
            label.textColor = UIColor.white
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
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
        }
        
        private func setup() {
            addSubviews()
        }
        
        func addSubviews() {
            contentView.addSubview(wrapperView)
            wrapperView.addSubview(label)
            
            NSLayoutConstraint.activate([
                
                wrapperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                wrapperView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor),
                wrapperView.topAnchor.constraint(equalTo: contentView.topAnchor),
                wrapperView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                
                label.leadingAnchor.constraint(equalTo: wrapperView.leadingAnchor, constant: 5),
                label.leadingAnchor.constraint(equalTo: wrapperView.trailingAnchor, constant: -5),
                label.topAnchor.constraint(equalTo: wrapperView.topAnchor, constant: 5),
                label.bottomAnchor.constraint(equalTo: wrapperView.bottomAnchor, constant: -5),
            
            ])
        }
        
        func configure(title: String, isSelected: Bool, selectedColor: UIColor = .white, unselectedColor: UIColor = .black) {
            label.text = title
            label.textColor = isSelected ? selectedColor : unselectedColor
            wrapperView.backgroundColor = isSelected ? unselectedColor : selectedColor
        }
    }

