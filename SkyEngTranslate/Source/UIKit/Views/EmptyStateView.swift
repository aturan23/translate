//
//  EmptyStateView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit

final class EmptyStateView: UIView {
    enum Constants {
        static let imageSize: CGSize = .init(width: 158, height: 140)
    }
    
    // MARK: - UI components
    
    private let imageView = UIImageView(image: Asset.iconNoData.image)
    private let messageLabel = LabelFactory()
        .make(withStyle: .paragraphCaption,
              textColor: Color.textLowContrast,
              textAlignment: .center)
    
    // MARK: - Init
    
    init(message: String) {
        super.init(frame: .zero)
        backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        setupViewsHierarchy()
        configureConstraints()
        messageLabel.setAttributedText(to: message)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func set(image: UIImage) {
        imageView.image = image
    }
    
    // MARK: - Private methods
    
    private func setupViewsHierarchy() {
        [imageView, messageLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(Constants.imageSize.height)
            make.width.lessThanOrEqualTo(Constants.imageSize.width)
            make.bottom.equalTo(snp.centerY).offset(30)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(LayoutGuidance.offset)
            make.centerX.equalToSuperview()
        }
    }
}
