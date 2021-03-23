//
//  MainPageRouter.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

class MainPageRouter: MainPageRouterInput {
    
	weak var viewController: BaseViewController?
    private var detailPageAssembly: DetailPageModuleAssembly?
    
    init(detailPageAssembly: DetailPageModuleAssembly?) {
        self.detailPageAssembly = detailPageAssembly
    }

	// ------------------------------
    // MARK: - MainPageRouterInput methods
    // ------------------------------

    func routeToDetail(with model: Meaning) {
        guard let controller = detailPageAssembly?.assemble({ (moduleInput) in
            moduleInput.configure(data: .init(model: model))
            return nil
        }) else { return }
        viewController?.navigationController?.pushViewController(controller, animated: true)
    }
}
