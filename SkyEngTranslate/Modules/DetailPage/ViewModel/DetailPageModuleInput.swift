//
//  DetailPageModuleInput.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

/// Adapter struct for DetailPage initial configuration 
/// through DetailPageModuleInput
struct DetailPageConfigData { }

/// Protocol with public methods to configure DetailPage 
/// from its parent module (usually implemented by this module's ViewModel)
protocol DetailPageModuleInput: class {
	/// public configuration method for parent modules (add configurating parameters)
    func configure(data: DetailPageConfigData)
}
