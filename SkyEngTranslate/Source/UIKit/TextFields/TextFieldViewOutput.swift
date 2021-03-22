//
//  TextFieldViewOutput.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

protocol TextFieldViewOutput: class {
    func didChange(text: String)
    func didCompleteMask(with value: String)
}
