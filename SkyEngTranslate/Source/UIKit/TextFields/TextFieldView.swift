//
//  TextFieldView.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit
import SnapKit

final class TextFieldView: UIView {
    enum Constants {
        static let defaultBorderWidth: CGFloat = 1
        static let activeBorderWidth: CGFloat = 2
        static let errorHintAnimationDuration: Double = 0.3
        static let errorLabelHeight: CGFloat = 24
        static let containerHeight: CGFloat = 64
        static let rightIconSize: CGSize = .init(width: 24, height: 24)
        static let cornerRadius: CGFloat = 16
    }
    
    enum State: Equatable {
        case regular
        case active
        case filled
        case error(message: String?)
    }
    
    // MARK: - Public properties
    
    var keyboardType: UIKeyboardType = .default {
        didSet {
            textField.keyboardType = keyboardType
        }
    }
    
    var title: String {
        get { placeholderLabel.text ?? "" }
        set { placeholderLabel.setAttributedText(to: newValue) }
    }
    
    weak var output: TextFieldViewOutput?
    
    // MARK: - Private properties
    
    private var borderColor = Color.inputBorderRegular {
        didSet {
            backgroundView.layer.borderColor = borderColor.cgColor
        }
    }
    private var borderWidth: CGFloat = Constants.defaultBorderWidth {
        didSet {
            backgroundView.layer.borderWidth = borderWidth
        }
    }
    private var placeholderTextColor = Color.textLowContrast {
        didSet {
            placeholderLabel.textColor = placeholderTextColor
        }
    }
    private var errorLabelTopConstraint: Constraint?
    private var rightViewMode: UITextField.ViewMode = .never {
        didSet {
            if rightViewMode == .always {
                rightIconButton.isHidden = false
            }
        }
    }
    private var rightButtonTapAction: (() -> Void)?
    private var currentState: State = .regular
    
    // MARK: - UI components
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = Color.inputFillRegular
        view.layer.cornerRadius = Constants.cornerRadius
        return view
    }()
    private lazy var containerView: UIView = {
        let view = UIView()
        let tapGestRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(didTapContainerView))
        view.addGestureRecognizer(tapGestRecognizer)
        return view
    }()
    
    private let labelFactory = LabelFactory()
    private lazy var placeholderLabel = labelFactory
        .make(withStyle: .inputLabel, textColor: Color.textLowContrast)
    
    private lazy var errorLabel = labelFactory
        .make(withStyle: .inputHint, textColor: Color.textError)
    
    private lazy var errorHolderView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var rightIconButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: Constants.rightIconSize))
        button.isHidden = true
        button.addTarget(self, action: #selector(didTapRightIconButton), for: .touchUpInside)
        return button
    }()
    
    var leftView: UIView? {
        didSet {
            guard oldValue != leftView else {
                return
            }
            if let leftView = leftView {
                addSubview(leftView)
                leftView.snp.makeConstraints {
                    $0.left.equalTo(LayoutGuidance.offset)
                    $0.centerY.equalTo(backgroundView)
                }
                layoutInputsContainer(for: leftView)
            } else {
                oldValue?.removeFromSuperview()
                layoutInputsContainer()
            }
        }
    }
    
    override var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    private let textField: MaskedTextfield
    
    // MARK: - Init
    
    init(title: String = "",
         prefix: String = "",
         formatPattern: String = "",
         placeholderChar: String = "",
         disabledSymbolsRegex: String? = nil,
         editingActions: [EditingAction]? = nil) {
        textField = MaskedTextfield(prefix: prefix,
                                    formatPattern: formatPattern,
                                    placeholderChar: placeholderChar,
                                    disabledSymbolsRegex: disabledSymbolsRegex,
                                    editingActions: editingActions)
        super.init(frame: .zero)
        placeholderLabel.setAttributedText(to: title)
        textField.maskedDelegate = self
        textField.onTextDidChange = { [weak self] in
            guard let self = self else { return }
            self.apply(state: .active)
            if self.rightViewMode == .whileEditing {
                self.rightIconButton.isHidden = !self.textField.hasValue
            }
            self.output?.didChange(text: $0)
        }
        textField.tintColor = Color.mainBlack
        textField.font = UIFont.regular(size: 17)
        setupViewHierarchy()
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public methods
    
    func set(text: String?) {
        if let text = text {
            textField.set(text: text)
        }
        if textField.isFirstResponder {
            apply(state: .active)
        } else if textField.hasValue {
            apply(state: .filled)
        } else {
            apply(state: .regular)
        }
    }
    
    func getText() -> String {
        return textField.publicRealString
    }
    
    func showError(message: String? = nil) {
        apply(state: .error(message: message))
    }
    
    // MARK: - Overriden methods
    
    @discardableResult
    override func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult
    override func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    // MARK: - Private methods
    
    private func apply(state: State) {
        switch state {
        case .regular:
            borderColor = Color.inputBorderRegular
            borderWidth = Constants.defaultBorderWidth
            placeholderTextColor = Color.textLowContrast
            animatePlaceholder(minimize: false)
            textField.isHidden = true
            backgroundView.backgroundColor = Color.inputFillRegular
            hideErrorHint()
        case .active:
            borderColor = Color.mainBlue
            borderWidth = Constants.activeBorderWidth
            placeholderTextColor = Color.textHighContrast
            animatePlaceholder(minimize: true)
            textField.isHidden = false
            backgroundView.backgroundColor = .white
            hideErrorHint()
        case .filled:
            if case .error = currentState {
                break
            }
            borderColor = Color.inputBorderRegular
            borderWidth = Constants.defaultBorderWidth
            placeholderTextColor = Color.textLowContrast
            animatePlaceholder(minimize: true)
            textField.isHidden = false
            backgroundView.backgroundColor = Color.inputFillRegular
            hideErrorHint()
        case .error(let message):
            let offset: CGFloat = message ?? "" == "" ? -Constants.errorLabelHeight : 4
            UIView.animate(withDuration: Constants.errorHintAnimationDuration) { [weak self] in
                guard let self = self else { return }
                self.borderColor = Color.textError
                self.borderWidth = Constants.defaultBorderWidth
                if !self.textField.hasValue {
                    self.placeholderTextColor = Color.textError
                }
                self.errorLabel.setAttributedText(to: message)
                self.errorLabelTopConstraint?.update(offset: offset)
                self.backgroundView.backgroundColor = Color.inputFillRegular
                self.layoutIfNeeded()
            }
        }
        currentState = state
    }
    
    private func hideErrorHint() {
        UIView.animate(withDuration: Constants.errorHintAnimationDuration) { [weak self] in
            guard let self = self else { return }
            self.errorLabel.setAttributedText(to: nil)
            self.errorLabelTopConstraint?.update(offset: -Constants.errorLabelHeight)
            self.layoutIfNeeded()
        }
    }
    
    private func setupViewHierarchy() {
        [placeholderLabel, textField, rightIconButton].forEach {
            containerView.addSubview($0)
        }
        errorHolderView.addSubview(errorLabel)
        
        [backgroundView, containerView, errorHolderView].forEach {
            addSubview($0)
        }
    }
    
    private func layoutViews() {
        backgroundView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(Constants.containerHeight)
        }
        layoutInputsContainer()
        placeholderLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offset)
            $0.centerY.equalToSuperview()
        }
        rightIconButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalTo(-LayoutGuidance.offset)
            $0.size.equalTo(24)
        }
        textField.snp.makeConstraints {
            $0.top.equalTo(28)
            $0.height.equalTo(24)
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offset)
        }
        errorHolderView.snp.makeConstraints {
            $0.top.equalTo(backgroundView.snp.bottom)
            $0.left.right.equalTo(backgroundView)
            $0.bottom.equalToSuperview()
        }
        errorLabel.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            errorLabelTopConstraint = $0.top.equalTo(-Constants.errorLabelHeight).constraint
        }
        apply(state: .regular)
    }
    
    private func layoutInputsContainer(for leftView: UIView? = nil) {
        containerView.snp.remakeConstraints {
            $0.top.right.equalToSuperview()
            $0.height.equalTo(Constants.containerHeight)
            if let leftView = leftView {
                $0.left.equalTo(leftView.snp.right).offset(-LayoutGuidance.offsetQuarter)
            } else {
                $0.left.equalToSuperview()
            }
        }
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    private func animatePlaceholder(minimize: Bool) {
        UIView.transition(
            with: placeholderLabel,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { [weak self] in
                guard let self = self else { return }
                if minimize {
                    self.placeholderLabel.font = UIFont.regular(size: 14)
                    let transform = CGAffineTransform(translationX: 0, y: -15)
                    self.placeholderLabel.transform = transform
                } else {
                    self.placeholderLabel.font = UIFont.regular(size: 17)
                    self.placeholderLabel.transform = .identity
                }
            }
        )
    }
    
    @objc private func didTapContainerView() {
        textField.becomeFirstResponder()
    }
    
    @objc private func didTapRightIconButton() {
        rightButtonTapAction?()
    }
}

// MARK: - MaskedTextFieldDelegate

extension TextFieldView: MaskedTextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: MaskedTextfield) {
        apply(state: .active)
    }
    
    func textFieldDidEndEditing(_ textField: MaskedTextfield,
                                reason: UITextField.DidEndEditingReason) {
        apply(state: textField.hasValue ? .filled : .regular)
    }
    
    func textFieldDidCompleteMask(with value: String) {
        output?.didCompleteMask(with: value)
    }
}

// MARK: - Decoration

extension TextFieldView {
    func withClearButton() -> TextFieldView {
        rightButtonTapAction = { [weak self] in
            self?.textField.clear()
            self?.textField.becomeFirstResponder()
        }
        rightIconButton.setImage(Asset.iconClearTextfield.image, for: .normal)
        rightViewMode = .whileEditing
        return self
    }
}
