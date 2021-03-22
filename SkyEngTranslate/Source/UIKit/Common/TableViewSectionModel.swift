//
//  TableViewSectionModel.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

final class TableViewSectionModel<Item> {
    
    let title: String?
    let headerHeight: CGFloat
    let footerHeight: CGFloat
    let backgroundColor: UIColor
    var items: [Item]
    var onSelection: ((IndexPath) -> Void)?
    
    init(title: String?, items: [Item], headerHeight: CGFloat = 32,
         footerHeight: CGFloat = 0, backgroundColor: UIColor = .clear,
         onSelection: @escaping ((IndexPath) -> Void)) {
        self.title = title
        self.items = items
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
        self.backgroundColor = backgroundColor
        self.onSelection = onSelection
    }
}
