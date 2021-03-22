//
//  LogoImageView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

private enum Constants {
    static let iconCornerRadius: CGFloat = 15
    static let iconSize: CGFloat = 40
}

extension UIImageView {
    static func makeForLogo() -> UIImageView {
        let view = UIImageView(image: UIImage(Color.mainBlue))
        view.contentMode = .scaleAspectFit
        view.layer.borderWidth = 0.5
        view.layer.borderColor = Color.inputBorderRegular.cgColor
        view.layer.cornerRadius = Constants.iconCornerRadius
        view.clipsToBounds = true
        view.kf.indicatorType = .activity
        view.snp.makeConstraints {
            $0.size.equalTo(Constants.iconSize)
        }
        return view
    }
}
