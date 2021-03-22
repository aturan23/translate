//
//  MainPageViewController.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

import UIKit
import SnapKit

class MainPageViewController: BaseViewController, MainPageViewInput {

    enum Constants {
        static let tableViewEstimatedRowHeight: CGFloat = 72
        static let continueButtonHiddenInset: CGFloat = -100
    }
    
    // ------------------------------
    // MARK: - Properties
    // ------------------------------

    var output: MainPageViewOutput?
    private var searchBtnBottomConstraint: Constraint?

    // ------------------------------
    // MARK: - UI components
    // ------------------------------

    private let textField = TextFieldView(title: "Слово", editingActions: [.paste, .copy])
    private lazy var searchButton: Button = {
        let button = Button.makePrimary(with: "Поиск")
        button.touchUpInside = { [weak self] in
            self?.output?.didTapSearchButton()
        }
        return button
    }()
    
    // ------------------------------
    // MARK: - Life cycle
    // ------------------------------

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        output?.didLoad()
    }

    // ------------------------------
    // MARK: - MainPageViewInput
    // ------------------------------

    func display(viewAdapter: MainPageViewAdapter) { }
    
    func showInputError(message: String) {
        textField.showError(message: message)
    }
    
    func endEditing() {
        view.endEditing(true)
    }
    
    func getFieldText() -> String {
        textField.getText()
    }

    // ------------------------------
    // MARK: - Private methods
    // ------------------------------

    private func setupViews() {
        view.backgroundColor = Color.backgroundMain

        setupViewsHierarchy()
        setupConstraints()
    }

    private func setupViewsHierarchy() {
        [textField, searchButton].forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(LayoutGuidance.offsetThreeQuarters * 2)
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offset)
        }
        searchButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offset)
            searchBtnBottomConstraint = $0.bottom.equalToSuperview()
                .inset(Constants.continueButtonHiddenInset).constraint
        }
    }
    
    private func moveButton(bottomInset: CGFloat) {
        let animations = { [weak self] in
            self?.searchBtnBottomConstraint?.update(inset: bottomInset)
            self?.view.layoutIfNeeded()
        }
        let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.9, animations: {
            animations()
        })
        animator.startAnimation()
    }
}

// ------------------------------
// MARK: - KeyboardListening
// ------------------------------

extension MainPageViewController: KeyboardListening {
    
    func keyboardWillShow(notification: NSNotification) {
        guard let info = notification.userInfo,
            let keyboardFrame: NSValue = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        if textField.isFirstResponder {
            moveButton(bottomInset: LayoutGuidance.offsetHalf + keyboardHeight)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        moveButton(bottomInset: Constants.continueButtonHiddenInset)
    }
}
