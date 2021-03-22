//
//  SearchService.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

final class SearchService: SearchServiceProtocol {
    
    // MARK: - Properties
    
    private let dataProvider: NetworkDataProvider<SearchTarget>
    
    // MARK: - Init
    
    init(dataProvider: NetworkDataProvider<SearchTarget>) {
        self.dataProvider = dataProvider
    }
    
    // MARK: - SearchServiceProtocol
    
    func getWords(text: String, completion: @escaping (APIResult<String>) -> ()) {
        dataProvider.request(.search(text: text)) { (result: APIResult<String>) in
            switch result {
            case .success(let response):
                print(response)
            case .failure(let error):
                print(error.message)
            }
        }
    }
}
