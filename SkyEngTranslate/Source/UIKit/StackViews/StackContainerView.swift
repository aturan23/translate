//
//  StackContainerView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23.03.2021.
//

import UIKit

class StackContainerView: UIView {

    var axis: NSLayoutConstraint.Axis = .vertical {
        didSet {
            stackView.axis = axis
        }
    }

    var distribution: UIStackView.Distribution = .fill {
        didSet {
            stackView.distribution = distribution
        }
    }

    var bgColor: UIColor = .clear {
        didSet {
            backgroundColor = bgColor
            stackView.backgroundColor = bgColor
        }
    }
    
    var arrangedSubviews: [UIView] {
        return stackView.arrangedSubviews
    }

    let stackView = UIStackView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        stackView.axis = axis
        backgroundColor = bgColor
        stackView.backgroundColor = bgColor
        addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func add(view: UIView, at index: Int? = nil) {
        if let index = index {
            stackView.insertArrangedSubview(view, at: index)
        } else {
            stackView.addArrangedSubview(view)
        }
    }

    func remove(view: UIView) {
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
    func removeAll() {
        stackView.arrangedSubviews.forEach(remove(view:))
    }

    convenience init() {
        self.init(frame: CGRect.zero)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func addSpaceView(with spacing: CGFloat, at index: Int? = nil) {
        let spaceView = UIView()
        spaceView.snp.makeConstraints {
            $0.height.equalTo(spacing)
        }
        add(view: spaceView, at: index)
    }
}
