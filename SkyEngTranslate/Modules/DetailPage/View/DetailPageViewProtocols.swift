//
//  DetailPageViewProtocols.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

protocol DetailPageViewInput: class {
    func display(viewAdapter: DetailPageViewAdapter)
}

protocol DetailPageViewOutput {
    func didLoad()
}
