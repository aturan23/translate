//
//  SearchTarget.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Moya

enum SearchTarget {
    case search(text: String)
}

extension SearchTarget: BaseTargetType {
    
    var path: String {
        switch self {
        case .search:
            return "words/search"
        }
    }
    
    var task: Task {
        switch self {
        case .search(let text):
            return .requestParameters(
                parameters: ["search": text],
                encoding: URLEncoding.default)
        }
    }
}
