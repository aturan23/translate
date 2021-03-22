//
//  Word.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Foundation

struct Word: Codable {
    let id: Int
    let text: String
    let meanings: [Meaning]
}

struct Meaning: Codable {
    let id: Int
    let translation: Translation
    let previewUrl: URL?
    let transcription: String
    
    enum CodingKeys: String, CodingKey {
        case id, translation, previewUrl, transcription
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        translation = try container.decode(Translation.self, forKey: .translation)
        let preview = try container.decode(String.self, forKey: .previewUrl).replacingOccurrences(of: "//", with: "http://")
        previewUrl = URL(string: preview)
        transcription = try container.decode(String.self, forKey: .transcription)
    }
}

struct Translation: Codable {
    let text: String
    let note: String?
}
