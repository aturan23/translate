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
    
    func getWords(text: String, completion: @escaping (APIResult<[Word]>) -> ()) {
        dataProvider.request(.search(text: text)) { (result: APIResult<[Word]>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getMeaning(id: Int, completion: @escaping (APIResult<[DetailedMeaning]>) -> ()) {
        dataProvider.request(.meaning(id: id)) { (result: APIResult<[DetailedMeaning]>) in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
