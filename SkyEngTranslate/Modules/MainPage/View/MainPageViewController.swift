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
        view.backgroundColor = .green

        setupViewsHierarchy()
        setupConstraints()
    }

    private func setupViewsHierarchy() {

    }

    private func setupConstraints() {
        
    }
}
