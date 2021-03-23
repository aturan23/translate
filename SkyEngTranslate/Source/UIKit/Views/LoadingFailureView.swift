//
//  LoadingFailureView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit

final class LoadingFailureView: UIView {
    enum Constants {
        static let imageSize: CGSize = .init(width: 158, height: 120)
        static let retryButtonSize: CGFloat = 40
    }
    
    // MARK: - UI components
    
    private let imageView = UIImageView(image: Asset.iconNoData.image)
    private let messageLabel = LabelFactory()
        .make(withStyle: .paragraphCaption,
              textColor: Color.textLowContrast,
              textAlignment: .center)
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setImage(Asset.iconRefresh.image, for: .normal)
        button.addTarget(self, action: #selector(didTapRetryButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    var retryAction: (() -> Void)?
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        setupViewsHierarchy()
        configureConstraints()
        setupTitles()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func setupTitles() {
        messageLabel.setAttributedText(to: "Не удалось загрузить")
    }
    
    // MARK: - Private methods
    
    private func setupViewsHierarchy() {
        [imageView, messageLabel, retryButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Constants.imageSize.height),
            imageView.widthAnchor.constraint(equalToConstant: Constants.imageSize.width),
            imageView.bottomAnchor.constraint(equalTo: centerYAnchor, constant: 30),
            messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor,
                                              constant: LayoutGuidance.offsetHalf),
            messageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            retryButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            retryButton.heightAnchor.constraint(equalToConstant: Constants.retryButtonSize),
            retryButton.widthAnchor.constraint(equalToConstant: Constants.retryButtonSize)
        ])
    }
    
    @objc private func didTapRetryButton() {
        retryAction?()
    }
}
