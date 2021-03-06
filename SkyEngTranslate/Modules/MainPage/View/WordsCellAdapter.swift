//
//  WordsCellAdapter.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Foundation

struct WordsCellAdapter: LogoCellAdapter {
    var title: String
    var subtitle: String?
    var imageUrl: URL?
    var isLast: Bool
}

extension WordsCellAdapter {
    static func makeFor(word: Meaning, isLast: Bool) -> Self {
        return .init(title: word.translation.text,
                     subtitle: word.translation.text,
                     imageUrl: word.previewUrl,
                     isLast: isLast)
    }
}
