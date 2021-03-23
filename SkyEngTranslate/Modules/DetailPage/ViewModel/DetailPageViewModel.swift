//
//  DetailPageViewModel.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

class DetailPageViewModel: DetailPageViewOutput {

    // ------------------------------
	// MARK: - Properties
    // ------------------------------

    weak var view: DetailPageViewInput?
    var router: DetailPageRouterInput?
    weak var moduleOutput: DetailPageModuleOutput?

    // ------------------------------
    // MARK: - DetailPageViewOutput methods
    // ------------------------------

    func didLoad() {
        view?.display(viewAdapter: DetailPageViewAdapter())
    }

    // ------------------------------
    // MARK: - Private methods
    // ------------------------------
    
}

// ------------------------------
// MARK: - DetailPageModuleInput methods
// ------------------------------

extension DetailPageViewModel: DetailPageModuleInput {
    func configure(data: DetailPageConfigData) { }
}
