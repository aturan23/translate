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
    var searchService: SearchServiceProtocol?

    // ------------------------------
    // MARK: - MainPageViewOutput methods
    // ------------------------------

    func didLoad() {
        view?.display(viewAdapter: MainPageViewAdapter())
    }
    
    func didTapSearchButton() {
        view?.endEditing()
        guard let text = view?.getFieldText(), !text.isEmpty else {
            view?.showInputError(message: "Недостаточно символов")
            return
        }
        getWords(from: text)
    }

    // ------------------------------
    // MARK: - Private methods
    // ------------------------------
    
    private func getWords(from text: String) {
        searchService?.getWords(text: text, completion: { (result) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error.message)
            }
        })
    }
}

// ------------------------------
// MARK: - MainPageModuleInput methods
// ------------------------------

extension MainPageViewModel: MainPageModuleInput {
    func configure(data: MainPageConfigData) { }
}
