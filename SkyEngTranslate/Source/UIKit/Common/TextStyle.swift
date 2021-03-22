//
//  TextStyle.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

public enum TextStyle {
    /// Heading / H1 - 32 Semibold
    case headingH1
    
    /// Heading / H2 - 24 Semibold
    case headingH2
    
    /// Heading / H5 - 17 Semibold
    case headingH5
    
    /// Paragraph / Body - 17 Regular
    case paragraphBody
    
    /// Paragraph / Secondary - 15 Regular
    case paragraphSecondary
    
    /// Paragraph / Caption - 13 Regular
    case paragraphCaption
    
    /// Paragraph / CAPTION CAPS - 13 Semibold
    case paragraphCaptionCaps
    
    /// Paragraph  - 10 Regular
    case paragraph
    
    /// Button Primary / Button Label - 17 Semibold
    case buttonPrimary
    
    /// Text Button / Button Label - 17 Semibold
    case buttonSecondary
    
    /// Input General / Label--regular - 17 Reg
    case inputLabel
    
    /// Input General / Label--active - 14 Reg
    case inputLabelActive
    
    /// Input General / Text - 17 Reg
    case inputText
    
    /// Input General / Hint-error - 14 Reg
    case inputHint
    
    /// Menu / Small Helper Text - 12 Reg
    case smallHelper
    
    var lineSpacing: CGFloat {
        switch self {
        case .headingH2:
            return 3.25
        case .headingH5:
            return 2.2
        case .paragraphBody, .paragraphSecondary, .paragraphCaption, .inputHint:
            return 4
        default:
            return 0
        }
    }
    
    var kern: CGFloat {
        switch self {
        case .headingH1, .headingH2, .headingH5:
            return 0.2
        case .paragraphBody, .buttonPrimary, .buttonSecondary, .inputText, .inputLabel, .smallHelper:
            return 0.3
        case .paragraphSecondary, .inputLabelActive, .inputHint:
            return 0.4
        case .paragraphCaption, .paragraph:
            return 0.5
        case .paragraphCaptionCaps:
            return 0.6
        }
    }
    
    var font: UIFont {
        switch self {
        case .headingH1:
            return .semibold(size: 32)
        case .headingH2:
            return .semibold(size: 24)
        case .headingH5, .buttonPrimary, .buttonSecondary:
            return .semibold(size: 17)
        case .paragraphBody, .inputText, .inputLabel:
            return .regular(size: 17)
        case .paragraphSecondary:
            return .regular(size: 15)
        case .inputLabelActive, .inputHint:
            return .regular(size: 14)
        case .paragraphCaption:
            return .regular(size: 13)
        case .smallHelper:
            return .regular(size: 12)
        case .paragraphCaptionCaps:
            return .semibold(size: 13)
        case .paragraph:
            return .semibold(size: 10)
        }
    }
}
