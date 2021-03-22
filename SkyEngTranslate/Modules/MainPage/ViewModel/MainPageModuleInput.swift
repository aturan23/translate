//
//  MainPageModuleInput.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

/// Adapter struct for MainPage initial configuration 
/// through MainPageModuleInput
struct MainPageConfigData { }

/// Protocol with public methods to configure MainPage 
/// from its parent module (usually implemented by this module's ViewModel)
protocol MainPageModuleInput: class {
	/// public configuration method for parent modules (add configurating parameters)
    func configure(data: MainPageConfigData)
}
