//
//  LogoTableSectionHeaderView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

final class LogoTableSectionHeaderView: UIView {
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = LabelFactory()
        .make(withStyle: .paragraphCaptionCaps, textColor: Color.textLowContrast)
    
    // MARK: - View's Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
        configureConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureViews()
        configureConstraints()
    }
    
    // MARK: - Configurations
    
    private func configureViews() {
        backgroundColor = .clear
        addSubview(titleLabel)
    }
    
    private func configureConstraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(LayoutGuidance.offset)
            make.right.equalToSuperview().offset(-LayoutGuidance.offset)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-2)
        }
    }
    
    // MARK: - Actions
    
    func setTitle(_ string: String?) {
        titleLabel.setAttributedText(to: string?.uppercased())
    }
}
