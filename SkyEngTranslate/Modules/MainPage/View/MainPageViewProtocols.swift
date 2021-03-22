//
//  MainPageViewProtocols.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

protocol MainPageViewInput: class {
    func display(viewAdapter: MainPageViewAdapter)
}

protocol MainPageViewOutput {
    func didLoad()
    func didTapSearchButton()
}
