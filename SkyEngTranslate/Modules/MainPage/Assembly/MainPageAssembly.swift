//
//  MainPageAssembly.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

typealias MainPageConfiguration = (MainPageModuleInput) -> MainPageModuleOutput?

final class MainPageModuleAssembly: BaseModuleAssembly {
    /// Assembles Module components and returns a target controller
    ///
    /// - Parameter configuration: optional configuration closure called by module owner
    /// - Returns: Assembled module's ViewController
    func assemble(_ configuration: MainPageConfiguration? = nil) -> BaseViewController {
        let viewController = MainPageViewController()
        let router = MainPageRouter()
        let viewModel = MainPageViewModel()
        viewModel.view = viewController
        viewModel.router = router
        viewModel.searchService = injection.inject(SearchServiceProtocol.self)
        router.viewController = viewController
        viewController.output = viewModel
        viewModel.moduleOutput = configuration?(viewModel)
        return viewController
    }
}
