//
//  MeaningCardView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit

class MeaningCardView: UIView, ShimmeringViewPresentable {
    
    private enum Constants {
        static let imageHeight: CGFloat = 160
        static let viewRadius: CGFloat = 16
    }
    
    // ------------------------------
    // MARK: - Properties
    // ------------------------------
    
    // ------------------------------
    // MARK: - UI components
    // ------------------------------
    
    lazy var compoundShimmeringViews = setupShimmeringViews()
    var shimmerableOriginalViews: [UIView]?
    private let labelFactory = LabelFactory()
    private lazy var titleLabel = labelFactory.make(
        withStyle: TextStyle.headingH2,
        textColor: .white)
    private lazy var subtitleLabel = labelFactory.make(
        withStyle: TextStyle.paragraphSecondary,
        textColor: .white)
    
    private let imageView = UIImageView()
    
    // ------------------------------
    // MARK: - Life cycle
    // ------------------------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(loading: Bool) {
        loading ? startShimmering() : stopShimmering()
    }
    
    func display(imageUrl: URL?, title: String, translation: String) {
        if let url = imageUrl {
            imageView.setImage(with: url)
        } else {
            imageView.image = Asset.empty.image
        }
        titleLabel.text = title
        subtitleLabel.text = translation
    }
    
    // ------------------------------
    // MARK: - Private methods
    // ------------------------------
    
    private func setupViews() {
        backgroundColor = Color.mainBlue
        layer.cornerRadius = Constants.viewRadius
        layer.masksToBounds = true
        
        setupViewsHierarchy()
        setupConstraints()
    }
    
    private func setupViewsHierarchy() {
        [imageView, titleLabel, subtitleLabel]
            .forEach(addSubview(_:))
    }
    
    private func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(Constants.imageHeight)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(LayoutGuidance.offsetThreeQuarters)
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offsetThreeQuarters)
        }
        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutGuidance.offsetQuarter)
            $0.left.right.bottom.equalToSuperview().inset(LayoutGuidance.offsetThreeQuarters)
        }
    }
    
    private func setupShimmeringViews() -> UIView {
        let shimmeringView = ShimmeringView(cornerRadius: Constants.viewRadius)
        addSubview(shimmeringView)
        shimmeringView.snp.makeConstraints {
            $0.top.width.equalToSuperview()
            $0.height.equalTo(240)
        }
        return shimmeringView
    }
}
