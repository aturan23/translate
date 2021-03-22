//
//  Word.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

struct Word: Codable {
    let id: Int
    let text: String
    let meanings: [Meaning]
}

struct Meaning: Codable {
    let id: Int
    let translation: Translation
}

struct Translation: Codable {
    let text: String
    let note: String?
}
