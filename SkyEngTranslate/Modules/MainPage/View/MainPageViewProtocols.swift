//
//  MainPageViewProtocols.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

protocol MainPageViewInput: class {
    func display(viewAdapter: MainPageViewAdapter)
    func getFieldText() -> String
    func showInputError(message: String)
    func endEditing()
    func showTableLoadingState()
    func showTableFailureState()
}

protocol MainPageViewOutput {
    func didLoad()
    func didTapSearchButton()
    func didTapRetryButton()
}
