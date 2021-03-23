//
//  SearchServiceProtocol.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Foundation

protocol SearchServiceProtocol {
    func getWords(text: String, completion: @escaping (APIResult<[Word]>) -> ())
    func getMeaning(id: Int, completion: @escaping (APIResult<DetailedMeaning>) -> ())
}
