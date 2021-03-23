//
//  ShimmeringView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit

final class ShimmeringView: UIView {
    
    private lazy var darkView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.inputBorderRegular
        return view
    }()
    
    private lazy var shinyView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    private var gradientLayer: CAGradientLayer!
    
    init(cornerRadius: CGFloat = 4.0) {
        super.init(frame: .zero)
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if gradientLayer == nil {
            gradientLayer = CAGradientLayer()
            gradientLayer.colors = [UIColor.clear.cgColor, UIColor.white.cgColor, UIColor.clear.cgColor]
            gradientLayer.locations = [0, 0.5, 1]
            gradientLayer.frame = CGRect(origin: .zero, size: frame.size)
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
            
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 2
            animation.fromValue = -frame.width
            animation.toValue = frame.width
            animation.repeatCount = Float.infinity
            animation.isRemovedOnCompletion = false
            gradientLayer.add(animation, forKey: "ShimmeringAnimation")
            shinyView.layer.mask = gradientLayer
        }
    }
    
    private func configureViews() {
        [darkView, shinyView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        NSLayoutConstraint.activate([
            darkView.leftAnchor.constraint(equalTo: leftAnchor),
            darkView.rightAnchor.constraint(equalTo: rightAnchor),
            darkView.bottomAnchor.constraint(equalTo: bottomAnchor),
            darkView.topAnchor.constraint(equalTo: topAnchor),
            
            shinyView.leftAnchor.constraint(equalTo: leftAnchor),
            shinyView.rightAnchor.constraint(equalTo: rightAnchor),
            shinyView.bottomAnchor.constraint(equalTo: bottomAnchor),
            shinyView.topAnchor.constraint(equalTo: topAnchor)
        ])
    }
}

