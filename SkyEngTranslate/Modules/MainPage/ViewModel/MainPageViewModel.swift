//
//  MainPageViewModel.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

class MainPageViewModel: MainPageViewOutput {

    // ------------------------------
	// MARK: - Properties
    // ------------------------------

    weak var view: MainPageViewInput?
    var router: MainPageRouterInput?
    weak var moduleOutput: MainPageModuleOutput?

    // ------------------------------
    // MARK: - MainPageViewOutput methods
    // ------------------------------

    func didLoad() {
        view?.display(viewAdapter: MainPageViewAdapter())
    }
    
    func didTapSearchButton() {
        
    }

    // ------------------------------
    // MARK: - Private methods
    // ------------------------------
    
}

// ------------------------------
// MARK: - MainPageModuleInput methods
// ------------------------------

extension MainPageViewModel: MainPageModuleInput {
    func configure(data: MainPageConfigData) { }
}
