//
//  UILabelExtension.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

extension UILabel {
    func setAttributedText(to text: String?) {
        guard let mutableAttributedText = attributedText?.mutableCopy() as? NSMutableAttributedString
            else {
                return
        }
        let newText = text ?? ""
        mutableAttributedText.mutableString
            .setString(newText.isEmpty ? LabelFactory.emptyText : newText)
        attributedText = mutableAttributedText
    }
    
    func setAttribute(key: NSAttributedString.Key, value: Any) {
        guard let mutableAttributedText = attributedText?.mutableCopy() as? NSMutableAttributedString
            else {
                return
        }
        let range = NSRange(location: 0, length: mutableAttributedText.string.count)
        mutableAttributedText.addAttribute(key, value: value, range: range)
        attributedText = mutableAttributedText
    }
    
    func setAttributedFont(to font: UIFont) {
        guard let mutableAttributedText = attributedText?.mutableCopy() as? NSMutableAttributedString
            else {
                return
        }
        let range = NSRange(location: 0, length: mutableAttributedText.string.count)
        mutableAttributedText.addAttribute(.font, value: font, range: range)
        attributedText = mutableAttributedText
    }
    
    func setAttributedTextColor(to color: UIColor) {
        guard let mutableAttributedText = attributedText?.mutableCopy() as? NSMutableAttributedString
            else {
                return
        }
        let range = NSRange(location: 0, length: mutableAttributedText.string.count)
        mutableAttributedText.addAttribute(.foregroundColor, value: color, range: range)
        attributedText = mutableAttributedText
    }
}
