//
//  UIImageExtension.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

extension UIImage {
    /**
     Create color rectangle as image.
     
     - Parameter color: The color to be created as an UIImage
     - Parameter size:  The size of the UIImage, no need to be set when creating
     */
    public convenience init?(
        _ color: UIColor,
        size: CGSize = CGSize(width: 1, height: 1)
    ) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else {
            return nil
        }
        self.init(cgImage: cgImage)
    }
}
