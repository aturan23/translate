//
//  MainPageViewModel.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

typealias WordsSectionModel = TableViewSectionModel<WordsCellAdapter>

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
        searchService?.getWords(text: text, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.view?.display(viewAdapter: self.buildAdapter(from: response))
            case .failure(let error):
                print(error.message)
            }
        })
    }
    
    private func buildAdapter(from words: [Word]) -> MainPageViewAdapter {
        let sectionModels = buildSectionModels(with: words)
        return MainPageViewAdapter(sectionModels: sectionModels)
    }
    
    private func buildSectionModels(with words: [Word]) -> [WordsSectionModel] {
        words.map { word -> WordsSectionModel in
            let adapters = word.meanings.map { WordsCellAdapter.makeFor(word: $0) }
            return WordsSectionModel(title: word.text,
                                     items: adapters,
                                     onSelection: {_ in})
        }
    }
}

// ------------------------------
// MARK: - MainPageModuleInput methods
// ------------------------------

extension MainPageViewModel: MainPageModuleInput {
    func configure(data: MainPageConfigData) { }
}
