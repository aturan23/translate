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
    var task: Task {
        switch self {
        case .search(let text):
            return .requestParameters(parameters: ["search": "apple"], encoding: URLEncoding.default)
        }
    }
}
