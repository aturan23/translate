//
//  Button.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

open class Button: UIButton {
    
    // MARK: - Properties
    /**
     Current loading state.
     */
    public var isLoading: Bool = false
    /**
     The flag that indicate if the shadow is added to prevent duplicate drawing.
     */
    public var shadowAdded: Bool = false
    /**
     The loading indicator used with the button.
     */
    open var indicator: UIView & IndicatorProtocol = UIActivityIndicatorView()
    /**
     Set to true to add shadow to the button.
     */
    open var withShadow: Bool = false
    /**
     The corner radius of the button
     */
    open var cornerRadius: CGFloat = 12.0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    /**
     Shadow view.
     */
    open var shadowLayerView: UIView?
    /**
     Get all views in the button. Views include the button itself and the shadow.
     */
    open var entireViewGroup: [UIView] {
        var views: [UIView] = [self]
        if let shadowLayerView = shadowLayerView {
            views.append(shadowLayerView)
        }
        return views
    }
    /**
    Closure for touchUpInside event handling in case if you're using closue pattern.
    */
    var touchUpInside: (() -> ())?
    /**
    Set true to disable button.
    */
    var isDisabled: Bool = false {
        didSet {
            isUserInteractionEnabled = !isDisabled
            if isDisabled {
                backgroundColor = disabledStateBackgroundColor?.withAlphaComponent(0.7)
            } else {
                backgroundColor = activeStateBackgroundColor
            }
        }
    }
    
    private var activeStateBackgroundColor: UIColor?
    private var disabledStateBackgroundColor: UIColor?
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addTarget(self, action: #selector(touchUpInside(sender:)), for: .touchUpInside)
    }
    /**
     Convenience init of theme button with required information
     */
    public convenience init(
        frame: CGRect = .zero,
        icon: UIImage? = nil,
        pressedIconColor: UIColor? = nil,
        text: String? = nil,
        textStyle: TextStyle,
        textColor: UIColor? = .blue,
        pressedTextColor: UIColor? = nil,
        backgroundColor: UIColor = .clear,
        pressedColor: UIColor? = nil,
        disabledColor: UIColor? = nil,
        cornerRadius: CGFloat = 0,
        borderWidth: CGFloat = 0,
        borderColor: UIColor = .clear,
        contentEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4),
        withShadow: Bool = false
    ) {
        self.init(frame: frame)
        configureTitle(style: textStyle,
                       text: text,
                       textColor: textColor,
                       pressedTextColor: pressedTextColor,
                       icon: icon)
        activeStateBackgroundColor = backgroundColor
        disabledStateBackgroundColor = disabledColor
        self.backgroundColor = backgroundColor
        if let disabledColor = disabledColor {
            setBackgroundImage(UIImage(disabledColor), for: .disabled)
        }
        if let pressedColor = pressedColor {
            setBackgroundImage(UIImage(pressedColor), for: .highlighted)
        }
        self.contentEdgeInsets = contentEdgeInsets
        layer.borderColor = borderColor.cgColor
        layer.borderWidth = borderWidth
        layer.cornerRadius = cornerRadius
        clipsToBounds = cornerRadius > 0
        self.withShadow = withShadow
        self.cornerRadius = cornerRadius
    }
    
    // MARK: - Life Cycle
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
    }
    
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        if shadowAdded || !withShadow { return }
        shadowAdded = true
        // Set up shadow layer
        shadowLayerView = UIView(frame: frame)
        guard let shadowLayer = shadowLayerView else {
            return
        }
        let shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04)
        shadowLayer.layer.sublayers?.removeAll(keepingCapacity: true)
        
        [CALayer.makeShadowed(color: shadowColor,
                              radius: 1,
                              rect: bounds,
                              cornerRadius: cornerRadius),
         CALayer.makeShadowed(color: shadowColor,
                              offset: .init(width: 0, height: 2),
                              radius: 6,
                              rect: bounds,
                              cornerRadius: cornerRadius),
         CALayer.makeShadowed(color: shadowColor,
                              offset: .init(width: 0, height: 10),
                              radius: 20,
                              rect: bounds,
                              cornerRadius: cornerRadius)]
            .forEach {
                $0.masksToBounds = false
                $0.frame = bounds
                shadowLayer.layer.addSublayer($0)
        }
        
        shadowLayer.backgroundColor = UIColor.clear
        shadowLayer.layer.masksToBounds = true
        shadowLayer.clipsToBounds = false
        superview?.insertSubview(shadowLayer, belowSubview: self)
    }
    
    
    
    // MARK: - Actions
    
    /**
     Display the loader inside the button.
     
     - Parameter userInteraction: Enable the user interaction while displaying the loader.
     - Parameter completion:      The completion handler.
     */
    open func showLoader(userInteraction: Bool, _ completion: (() -> Void)? = nil) {
        showLoader([titleLabel, imageView], userInteraction: userInteraction, completion)
    }
    
    private func showLoader(
        _ viewsToBeHide: [UIView?], userInteraction: Bool = false, _ completion: (() -> Void)? = nil
    ) {
        guard !subviews.contains(indicator) else {
            return
        }
        // Set up loading indicator
        indicator.radius = min(0.7 * frame.height / 2, indicator.radius)
        isLoading = true
        isUserInteractionEnabled = userInteraction
        UIView.transition(with: self, duration: 0.2, options: .curveEaseOut, animations: {
            viewsToBeHide.forEach { view in
                view?.alpha = 0.0
            }
        }) { [weak self] _ in
            guard let self = self else {
                return
            }
            self.addSubview(self.indicator)
            if self.isLoading {
                self.indicator.startAnimating()
            } else {
                self.hideLoader(completion)
            }
            completion?()
        }
    }
    /**
     Show a loader inside the button with image.
     
     - Parameter userInteraction: Enable user interaction while showing the loader.
     */
    open func showLoaderWithImage(userInteraction: Bool = false) {
        showLoader([titleLabel], userInteraction: userInteraction)
    }
    /**
     Hide the loader displayed.
     
     - Parameter completion: The completion handler.
     */
    open func hideLoader(_ completion: (() -> Void)? = nil) {
        isLoading = false
        isUserInteractionEnabled = true
        indicator.stopAnimating()
        indicator.removeFromSuperview()
        UIView.transition(with: self, duration: 0.2, options: .curveEaseIn, animations: {
            self.titleLabel?.alpha = 1.0
            self.imageView?.alpha = 1.0
        }) { _ in
            completion?()
        }
    }
    /**
     Make the content of the button fill the button.
     */
    public func fillContent() {
        contentVerticalAlignment = .fill
        contentHorizontalAlignment = .fill
    }
    
    public func set(title text: String?) {
        setAttributedTitleKeepingAttributes(to: text)
    }
    
    /**
     Configure title of the button according to attributes of the given style.
     */
    private func configureTitle(style: TextStyle,
                                text: String?,
                                textColor: UIColor?,
                                pressedTextColor: UIColor?,
                                icon: UIImage?) {
        var normalAttributes = LabelFactory.makeAttributes(for: style)
        var highlightedAttributes = normalAttributes
        if let textColor = textColor {
            normalAttributes[.foregroundColor] = textColor
            highlightedAttributes[.foregroundColor] = textColor
        }
        if let pressedTextColor = pressedTextColor {
            highlightedAttributes[.foregroundColor] = pressedTextColor
        }
        for state in UIButton.allControlStates {
            let attributes = state == .highlighted ? highlightedAttributes : normalAttributes
            let mutableAttributedString: NSMutableAttributedString
            if let icon = icon {
                let textAttachment = NSTextAttachment()
                let iconRect = CGRect(
                    x: 0,
                    y: (style.font.capHeight - icon.size.height).rounded() / 2,
                    width: icon.size.width,
                    height: icon.size.height
                )
                textAttachment.bounds = iconRect
                textAttachment.image = icon.withRenderingMode(.alwaysTemplate)
                let attributedString = NSAttributedString(attachment: textAttachment)
                mutableAttributedString = NSMutableAttributedString(attributedString: attributedString)
                if let text = text {
                    let titleString = NSAttributedString(string: "   " + text)
                    mutableAttributedString.append(titleString)
                }
            } else {
                mutableAttributedString = NSMutableAttributedString(string: text ?? LabelFactory.emptyText)
            }
            mutableAttributedString.addAttributes(attributes, range: NSRange(location: 0, length: mutableAttributedString.string.count))
            setAttributedTitle(mutableAttributedString, for: state)
        }
    }
    
    @objc private func touchUpInside(sender: Button) {
        touchUpInside?()
    }
    
    private func activityIndicatorValueChanged(isAnimating: Bool) {
        if isAnimating {
            showLoader(userInteraction: false)
        } else {
            hideLoader()
        }
    }
}
