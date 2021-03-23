//
//  DetailPageViewController.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

import UIKit

class DetailPageViewController: BaseViewController, DetailPageViewInput {

    // ------------------------------
    // MARK: - Properties
    // ------------------------------

    var output: DetailPageViewOutput?

    // ------------------------------
    // MARK: - UI components
    // ------------------------------
    
    private let cardView = MeaningCardView()

    // ------------------------------
    // MARK: - Life cycle
    // ------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        output?.didLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // ------------------------------
    // MARK: - DetailPageViewInput
    // ------------------------------

    func display(viewAdapter: DetailPageViewAdapter) {
        cardView.set(loading: true)
        guard let model = viewAdapter.model else { return }
        cardView.set(loading: false)
        title = model.title
        cardView.display(imageUrl: model.imageUrl, title: model.title, translation: model.translation.text)
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
        [cardView].forEach(view.addSubview(_:))
    }

    private func setupConstraints() {
        cardView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(LayoutGuidance.offset)
            $0.left.right.equalToSuperview().inset(LayoutGuidance.offset)
        }
    }
}
