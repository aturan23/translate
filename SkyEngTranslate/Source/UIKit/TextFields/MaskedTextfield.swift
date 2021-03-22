//
//  MaskedTextfield.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

public protocol MaskedTextFieldDelegate: class {
    func textFieldShouldBeginEditing(_ textField: MaskedTextfield) -> Bool
    func textFieldDidBeginEditing(_ textField: MaskedTextfield)
    func textFieldShouldEndEditing(_ textField: MaskedTextfield) -> Bool
    func textFieldDidEndEditing(_ textField: MaskedTextfield)
    func textFieldDidEndEditing(_ textField: MaskedTextfield, reason: UITextField.DidEndEditingReason)
    func textFieldDidChangeSelection(_ textField: MaskedTextfield)
    func textFieldShouldClear(_ textField: MaskedTextfield) -> Bool
    func textFieldShouldReturn(_ textField: MaskedTextfield) -> Bool
    func textFieldDidChange(_ textField: MaskedTextfield)
    func textFieldDidCompleteMask(with value: String)
}

extension MaskedTextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: MaskedTextfield) -> Bool {
        return true
    }
    func textFieldDidBeginEditing(_ textField: MaskedTextfield) {}
    func textFieldShouldEndEditing(_ textField: MaskedTextfield) -> Bool {
        return true
    }
    func textFieldDidEndEditing(_ textField: MaskedTextfield) {}
    func textFieldDidEndEditing(_ textField: MaskedTextfield, reason: UITextField.DidEndEditingReason) {}
    func textFieldDidChangeSelection(_ textField: MaskedTextfield) {}
    func textFieldShouldClear(_ textField: MaskedTextfield) -> Bool { return true }
    func textFieldShouldReturn(_ textField: MaskedTextfield) -> Bool { return true }
    func textFieldDidChange(_ textField: MaskedTextfield) {}
}

open class MaskedTextfield: UITextField {
    
// MARK: - Properties
    
    private static let lettersAndDigitsReplacementChar: String = "*"
    private static let anyLetterReplacementChar: String = "@"
    private static let lowerCaseLetterReplacementChar: String = "a"
    private static let upperCaseLetterReplacementChar: String = "A"
    private static let digitsReplacementChar: String = "#"
    private var allReplacements: [String] = []
    
    /**
     Var that holds the format pattern that you wish to apply
     to some text
     
     If the pattern is set to "" no mask would be applied and
     the textfield would behave like a normal one
     */
    private var formatPattern: String = ""
    
    /**
     Var that holds the prefix to be added to the textfield
     
     If the prefix is set to "" no string will be added to the beggining
     of the text
     */
    private var prefix: String = ""
    
    /**
     var that holds character for filler placeholder
        
     Default value is as provided
     */
    private var placeholderChar: String = "-"
    /**
     Var that have the maximum length, based on the mask set
     */
    open var maxLength: Int {
        get {
            return formatPattern.count + prefix.count
        }
    }
    
    /**
     Var that have the filler placeholder, based on the mask set
     */
    private var fillerPlaceholder: String {
        get {
            var string = "\(prefix)\(formatPattern)"
            allReplacements.forEach {
                string = string.replacingOccurrences(of: $0, with: placeholderChar)
            }
            return string
        }
    }
    /**
     Regular expression which defines enabled symbols to use
     */
    private var disabledSymbolsRegex: String?
    
    /**
     var that have real string, based on the mask set
     */
    private var realString: String = ""
    
    /**
     var to access real text to export
     */
    public var publicRealString: String {
        get {
            return realString
        }
    }
    
    /**
     action to call when text changed
     */
    public var onTextDidChange: ((String) -> Void)?
    
    /**
     var to know if user typed something or not
     */
    public var hasValue: Bool {
        let withoutPrefix = getStringWithoutPrefix(realString)
        let cleanValue = getFilteredString(withoutPrefix)
        return !cleanValue.isEmpty
    }
    
    /**
     array of menu actions that can be performed on the text field
     */
    private var editingActions: [EditingAction]?
    
    /**
     boolean value to define whether placeholder should be hidden or not, when it's value is empty
     */
    private var hidePlaceholderOnResign: Bool = true
    
    /**
     The receiver’s delegate
     */
    open weak var maskedDelegate: MaskedTextFieldDelegate?
    
    /**
     Color of the filled text.
     */
    public var filledTextColor: UIColor = Color.textHighContrast {
        didSet {
            setAttributedText()
            setCurrentCursorPosition()
        }
    }
    
// MARK: - Constructors
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    init(prefix: String,
         formatPattern: String,
         placeholderChar: String = "",
         disabledSymbolsRegex: String? = nil,
         editingActions: [EditingAction]? = nil,
         hidePlaceholderOnResign: Bool = true) {
        super.init(frame: .zero)
        allReplacements = [MaskedTextfield.lettersAndDigitsReplacementChar,
                           MaskedTextfield.anyLetterReplacementChar,
                           MaskedTextfield.lowerCaseLetterReplacementChar,
                           MaskedTextfield.upperCaseLetterReplacementChar,
                           MaskedTextfield.digitsReplacementChar]
        self.prefix = prefix
        self.formatPattern = formatPattern
        self.placeholderChar = placeholderChar == "" ? self.placeholderChar : placeholderChar
        self.disabledSymbolsRegex = disabledSymbolsRegex
        self.editingActions = editingActions
        self.hidePlaceholderOnResign = hidePlaceholderOnResign
        setAttributedText()
        self.setup()
    }
    
// MARK: - Private Methods
    
    fileprivate func setup() {
        delegate = self
    }
    
    private func getOnlyDigitsString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
        return charactersArray.joined(separator: "")
    }
    
    private func getOnlyLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.letters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    private func getUppercaseLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.uppercaseLetters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    private func getLowercaseLettersString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.lowercaseLetters.inverted)
        return charactersArray.joined(separator: "")
    }
    
    private func getFilteredString(_ string: String) -> String {
        let charactersArray = string.components(separatedBy: CharacterSet.alphanumerics.inverted)
        return charactersArray.joined(separator: "")
    }
    
    private func getStringWithoutPrefix(_ string: String) -> String {
        if string.range(of: self.prefix) != nil {
            if string.count > self.prefix.count {
                let prefixIndex = string.index(string.endIndex,
                                               offsetBy: (string.count - self.prefix.count) * -1)
                return String(string[prefixIndex...])
            } else if string.count == self.prefix.count {
                return ""
            }
            
        }
        return string
    }
    
// MARK: - Self Public Methods
    
    /**
     Func that formats the text based on formatPattern
     
     Override this function if you want to customize the behaviour of
     the class
     */
    // swiftlint:disable cyclomatic_complexity
    private func formatText(string: String) {
        var currentTextForFormatting = ""
        if string.count > 0 {
            currentTextForFormatting = self.getStringWithoutPrefix(string)
        }
        
        if self.maxLength > 0 {
            var formatterIndex = self.formatPattern.startIndex, currentTextForFormattingIndex = currentTextForFormatting.startIndex
            var finalText = ""
            
            currentTextForFormatting = self.getFilteredString(currentTextForFormatting)
            
            if currentTextForFormatting.count > 0 {
                while true {
                    let formatPatternRange = formatterIndex ..< formatPattern.index(after: formatterIndex)
                    let currentFormatCharacter = String(self.formatPattern[formatPatternRange])
                    
                    let currentTextForFormattingPatterRange = currentTextForFormattingIndex ..< currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    let currentTextForFormattingCharacter = String(currentTextForFormatting[currentTextForFormattingPatterRange])
                    
                    switch currentFormatCharacter {
                    case MaskedTextfield.lettersAndDigitsReplacementChar:
                        finalText += currentTextForFormattingCharacter
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                        formatterIndex = formatPattern.index(after: formatterIndex)
                    case MaskedTextfield.anyLetterReplacementChar:
                        let filteredChar = self.getOnlyLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case MaskedTextfield.lowerCaseLetterReplacementChar:
                        let filteredChar = self.getLowercaseLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case MaskedTextfield.upperCaseLetterReplacementChar:
                        let filteredChar = self.getUppercaseLettersString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    case MaskedTextfield.digitsReplacementChar:
                        let filteredChar = self.getOnlyDigitsString(currentTextForFormattingCharacter)
                        if !filteredChar.isEmpty {
                            finalText += filteredChar
                            formatterIndex = formatPattern.index(after: formatterIndex)
                        }
                        currentTextForFormattingIndex = currentTextForFormatting.index(after: currentTextForFormattingIndex)
                    default:
                        finalText += currentFormatCharacter
                        formatterIndex = formatPattern.index(after: formatterIndex)
                    }
                    
                    if formatterIndex >= self.formatPattern.endIndex ||
                        currentTextForFormattingIndex >= currentTextForFormatting.endIndex {
                        break
                    }
                }
            }
            
            if finalText.count > 0 {
                realString = "\(self.prefix)\(finalText)"
            } else {
                realString = finalText
            }
        } else {
            realString = string
        }
        if let disabledSymbolsRegex = disabledSymbolsRegex {
            realString = realString.replacingOccurrences(
                of: disabledSymbolsRegex, with: "", options: .regularExpression)
        }
        setAttributedText()
        setCurrentCursorPosition()
    }
    
    private func setAttributedText() {
        let prefixString = realString.count == 0 ? prefix : realString
        let attributedRealString = NSAttributedString(
            string: prefixString,
            attributes: [.kern: TextStyle.inputLabel.kern,
                         .foregroundColor: filledTextColor,
                         .font: TextStyle.inputLabel.font])
        let attributedResultString = NSMutableAttributedString(attributedString: attributedRealString)
        if fillerPlaceholder.count - prefixString.count >= 0 {
            let attributedFillerPlaceholderString = NSAttributedString(
                string: String(fillerPlaceholder.suffix(fillerPlaceholder.count - prefixString.count)),
                attributes: [.kern: TextStyle.inputLabel.kern,
                             .foregroundColor: Color.textLowContrast,
                             .font: TextStyle.inputLabel.font])
            attributedResultString.append(attributedFillerPlaceholderString)
        }
        attributedText = attributedResultString
    }
    
    func set(text: String) {
        realString = text
        maskedDelegate?.textFieldDidChange(self)
        formatText(string: realString)
        textChanged()
    }
    
    @discardableResult
    open override func becomeFirstResponder() -> Bool {
        super.becomeFirstResponder()
        let res = super.becomeFirstResponder()
        setAttributedText()
        setCurrentCursorPosition()
        return res
    }
    
    open override func resignFirstResponder() -> Bool {
        let res = super.resignFirstResponder()
        if isEmpty(), hidePlaceholderOnResign {
            self.attributedText = NSAttributedString(string: "")
        }
        return res
    }
    
    // method to get if real value is empty
    public func isEmpty() -> Bool {
        return realString.count == 0
    }
    
    // method for setting cursor based on mask
    private func setCurrentCursorPosition() {
        let arbitraryValue: Int = realString.count < prefix.count ? prefix.count : realString.count
        if let newPosition = position(from: beginningOfDocument,
                                      offset: arbitraryValue) {
            selectedTextRange = textRange(from: newPosition,
                                          to: newPosition)
        }
    }
    
    @objc public func clear() {
        realString = ""
        setAttributedText()
        setCurrentCursorPosition()
        textChanged()
    }
    
    /**
     method must be overrided by subclasses
     */
    func textChanged() {
        onTextDidChange?(realString)
        if isMaskComplete() {
            maskedDelegate?.textFieldDidCompleteMask(with: realString)
        }
    }
    
    private func isMaskComplete() -> Bool {
        let prefixString = realString.count == 0 ? prefix : realString
        return fillerPlaceholder.count == prefixString.count
    }
}

// MARK: - UITextFieldDelegate methods

extension MaskedTextfield: UITextFieldDelegate {
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return maskedDelegate?.textFieldShouldBeginEditing(self) ?? true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        maskedDelegate?.textFieldDidBeginEditing(self)
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return maskedDelegate?.textFieldShouldEndEditing(self) ?? true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        maskedDelegate?.textFieldDidEndEditing(self)
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        maskedDelegate?.textFieldDidEndEditing(self, reason: reason)
    }
    
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.count == 0 && range.length > 0 && realString.count > 0 {
            realString.removeLast()
        } else {
            realString += string
        }
        maskedDelegate?.textFieldDidChange(self)
        formatText(string: realString)
        textChanged()
        return false
    }
    
    open func textFieldDidChangeSelection(_ textField: UITextField) {
        maskedDelegate?.textFieldDidChangeSelection(self)
    }
    
    open func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return maskedDelegate?.textFieldShouldClear(self) ?? true
    }
    
    open func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return maskedDelegate?.textFieldShouldReturn(self) ?? true
    }
}

// MARK: - Editing menu actions

extension MaskedTextfield {
    override public func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        guard let editingActions = editingActions else {
            return true
        }
        for editingAction in editingActions {
            if action == Selector(editingAction.selectorId) {
                return true
            }
        }
        return false
    }
}

