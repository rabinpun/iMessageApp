//
//  String.swift
//  iMessageApp
//
//  Created by ebpearls on 10/01/2023.
//

import UIKit

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont, lineHeight: CGFloat? = nil) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        var attributes = [NSAttributedString.Key : Any]()
        attributes.updateValue(font, forKey: NSAttributedString.Key.font)
        if let lineHeight = lineHeight {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight
            attributes.updateValue(paragraphStyle, forKey: NSAttributedString.Key.paragraphStyle)
        }
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return ceil(boundingBox.height)
    }

    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)

        return ceil(boundingBox.width)
    }

}
