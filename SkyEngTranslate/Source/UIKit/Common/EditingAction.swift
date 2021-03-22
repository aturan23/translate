//
//  EditingAction.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

enum EditingAction {
    case copy
    case paste
    
    var selectorId: String {
        switch self {
        case .copy:
            return "copy:"
        case .paste:
            return "paste:"
        }
    }
}
