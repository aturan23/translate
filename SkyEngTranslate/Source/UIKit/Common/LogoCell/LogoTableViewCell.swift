//
//  LogoTableViewCell.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit
import SnapKit

class LogoTableViewCell: UITableViewCell {
    
    enum Constants {
        static let separatorLeftInset: CGFloat = 72
    }
    
    // MARK: - Properties
    
    // MARK: - UI components
    
    private let labelFactory = LabelFactory()
    private lazy var titleLabel = labelFactory
        .make(withStyle: .paragraphBody,
              textColor: Color.textHighContrast)
    private lazy var subtitleLabel = labelFactory
        .make(withStyle: .paragraphCaption,
              textColor: Color.textLowContrast)
    private let logoImageView = UIImageView.makeForLogo()
    private let separatorView = SeparatorView()
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func update(for adapter: LogoCellAdapter) {
        if let imageUrl = adapter.imageUrl {
            logoImageView.setImage(with: imageUrl)
        } else {
            logoImageView.image = Asset.defaultLogo.image
        }
        titleLabel.setAttributedText(to: adapter.title)
    }
    
    // MARK: - Private methods
    
    private func setupViews() {
        backgroundColor = .clear
        
        setupViewsHierarchy()
        setupConstraints()
    }
    
    private func setupViewsHierarchy() {
        [logoImageView, titleLabel, separatorView]
            .forEach(contentView.addSubview(_:))
    }
    
    private func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(LayoutGuidance.offset)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(LayoutGuidance.offset)
        }
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(logoImageView.snp.right).offset(LayoutGuidance.offsetThreeQuarters)
            $0.right.equalTo(-LayoutGuidance.offset)
            $0.centerY.equalToSuperview()
        }
        separatorView.snp.makeConstraints {
            $0.bottom.right.equalToSuperview()
            $0.left.equalTo(Constants.separatorLeftInset)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        logoImageView.image = nil
    }
}
