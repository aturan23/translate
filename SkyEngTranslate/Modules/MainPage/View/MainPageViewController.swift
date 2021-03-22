//
//  MainPageViewController.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

import UIKit

class MainPageViewController: BaseViewController, MainPageViewInput {

    // ------------------------------
    // MARK: - Properties
    // ------------------------------

    var output: MainPageViewOutput?

    // ------------------------------
    // MARK: - UI components
    // ------------------------------

    private let textField = TextFieldView(title: "Слово", editingActions: [.paste, .copy])
    
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

    // ------------------------------
    // MARK: - Private methods
    // ------------------------------

    private func setupViews() {
        view.backgroundColor = Color.backgroundMain

        setupViewsHierarchy()
        setupConstraints()
    }

    private func setupViewsHierarchy() {
        [textField].forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        textField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(LayoutGuidance.offsetThreeQuarters * 2)
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offset)
        }
    }
}

// ------------------------------
// MARK: - KeyboardListening
// ------------------------------

extension MainPageViewController: KeyboardListening {
    
    func keyboardWillShow(notification: NSNotification) {
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        
    }
}
