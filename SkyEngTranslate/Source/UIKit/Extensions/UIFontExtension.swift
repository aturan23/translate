//
//  UIFontExtension.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

extension UIFont {
    static func regular(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .regular)
    }
    
    static func semibold(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .semibold)
    }
    
    static func bold(size: CGFloat) -> UIFont {
        return .systemFont(ofSize: size, weight: .bold)
    }
}
