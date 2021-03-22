//
//  LogoCellAdapter.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

typealias LogoCellDetailParams = (text: String?, color: UIColor?, attributedText: NSAttributedString?)

protocol LogoCellAdapter {
    var title: String { get }
    var subtitle: String? { get }
    var attributedSubtitle: NSAttributedString? { get }
    var imageUrl: URL? { get }
}

extension LogoCellAdapter {
    var attributedSubtitle: NSAttributedString? { nil }
}
