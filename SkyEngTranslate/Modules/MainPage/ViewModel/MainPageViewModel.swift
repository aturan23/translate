//
//  MainPageViewModel.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

import Foundation

typealias WordsSectionModel = TableViewSectionModel<WordsCellAdapter>

class MainPageViewModel: MainPageViewOutput {
    
    // ------------------------------
	// MARK: - Properties
    // ------------------------------

    weak var view: MainPageViewInput?
    var router: MainPageRouterInput?
    weak var moduleOutput: MainPageModuleOutput?
    var searchService: SearchServiceProtocol?
    private var words: [Word] = []

    // ------------------------------
    // MARK: - MainPageViewOutput methods
    // ------------------------------

    func didLoad() {
        self.view?.display(viewAdapter: MainPageViewAdapter(sectionModels: []))
    }
    
    func didTapSearchButton() {
        view?.endEditing()
        guard let text = view?.getFieldText(), !text.isEmpty else {
            view?.showInputError(message: "Недостаточно символов")
            return
        }
        getWords(from: text)
    }
    
    func didTapRetryButton() {
        didTapSearchButton()
    }

    // ------------------------------
    // MARK: - Private methods
    // ------------------------------
    
    private func getWords(from text: String) {
        view?.showTableLoadingState()
        searchService?.getWords(text: text, completion: { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.words = response
                self.view?.display(viewAdapter: self.buildAdapter(from: response))
            case .failure(let error):
                print(error.message)
                self.view?.showTableFailureState()
            }
        })
    }
    
    private func buildAdapter(from words: [Word]) -> MainPageViewAdapter {
        let sectionModels = buildSectionModels(with: words)
        return MainPageViewAdapter(sectionModels: sectionModels)
    }
    
    private func buildSectionModels(with words: [Word]) -> [WordsSectionModel] {
        words.map { word in
            return WordsSectionModel(
                title: word.text,
                items: buildCellModels(from: word.meanings),
                onSelection: didSelectRowAt(indexPath:))
        }
    }
    
    private func didSelectRowAt(indexPath: IndexPath) {
        router?.routeToDetail(with: words[indexPath.section].meanings[indexPath.row])
    }
    
    private func buildCellModels(from meanings: [Meaning]) -> [WordsCellAdapter] {
        meanings.enumerated().map { (index, item) in
            WordsCellAdapter.makeFor(word: item, isLast: (meanings.count - 1) == index)
        }
    }
}

// ------------------------------
// MARK: - MainPageModuleInput methods
// ------------------------------

extension MainPageViewModel: MainPageModuleInput {
    func configure(data: MainPageConfigData) { }
}
