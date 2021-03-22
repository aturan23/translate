//
//  UIActivityIndicatorViewExtension.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

extension UIActivityIndicatorView: IndicatorProtocol {
    public var radius: CGFloat {
        get { frame.width / 2 }
        set {
            frame.size = CGSize(width: 2 * newValue, height: 2 * newValue)
            setNeedsDisplay()
        }
    }
    
    public var color: UIColor {
        get {
            return tintColor
        }
        set {
            tintColor = newValue
        }
    }
    // unused
    public func setupAnimation(in layer: CALayer, size: CGSize) {}
}
