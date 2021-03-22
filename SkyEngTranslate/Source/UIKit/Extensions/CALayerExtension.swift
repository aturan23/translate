//
//  CALayerExtension.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

extension CALayer {
    static func makeShadowed(
        color: UIColor = .black,
        alpha: Float = 1,
        offset: CGSize = .zero,
        radius: CGFloat = 4,
        rect: CGRect,
        cornerRadius: CGFloat = 0
    ) -> CALayer {
        let layer = CALayer()
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = alpha
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).cgPath
        layer.masksToBounds = false
        return layer
    }
}
