//
//  PrimaryButton.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

extension Button {
    static func makePrimary(with text: String? = nil) -> Button {
        let button = Button(text: text,
                            textStyle: .buttonPrimary,
                            textColor: .white,
                            backgroundColor: Color.mainBlue,
                            pressedColor: Color.mainBlack,
                            disabledColor: Color.mainBlue,
                            cornerRadius: 24,
                            withShadow: false)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        let indicatorView = UIActivityIndicatorView()
        indicatorView.style = UIActivityIndicatorView.Style.medium
        indicatorView.color = .white
        button.indicator = indicatorView
        return button
    }
}
