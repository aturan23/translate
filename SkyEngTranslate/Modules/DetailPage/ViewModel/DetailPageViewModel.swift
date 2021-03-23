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
    private var configData: DetailPageConfigData?
    var searchService: SearchServiceProtocol?

    // ------------------------------
    // MARK: - DetailPageViewOutput methods
    // ------------------------------

    func didLoad() {
        view?.display(viewAdapter: DetailPageViewAdapter(model: nil))
        fetchDetailedMeaning()
    }

    // ------------------------------
    // MARK: - Private methods
    // ------------------------------
    
    private func fetchDetailedMeaning() {
        guard let id = configData?.model.id else { return }
        searchService?.getMeaning(id: id, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let model):
                self.view?.display(viewAdapter: .init(model: model))
            case .failure(let error):
                print(error.message)
            }
        })
    }
}

// ------------------------------
// MARK: - DetailPageModuleInput methods
// ------------------------------

extension DetailPageViewModel: DetailPageModuleInput {
    func configure(data: DetailPageConfigData) {
        configData = data
    }
}
