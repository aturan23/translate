//
//  APIResult.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

enum APIResult<A> {
    case success(A)
    case failure(NetworkError)
    
    init(_ value: A?, or error: NetworkError) {
        if let value = value {
            self = .success(value)
        } else {
            self = .failure(error)
        }
    }
}
