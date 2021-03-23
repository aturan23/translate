//
//  DetailPageAssembly.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 23/03/2021.
//  Copyright © 2021 Assylkhan Turan. All rights reserved.
//

typealias DetailPageConfiguration = (DetailPageModuleInput) -> DetailPageModuleOutput?

final class DetailPageModuleAssembly: BaseModuleAssembly {
    /// Assembles Module components and returns a target controller
    ///
    /// - Parameter configuration: optional configuration closure called by module owner
    /// - Returns: Assembled module's ViewController
    func assemble(_ configuration: DetailPageConfiguration? = nil) -> BaseViewController {
        let viewController = DetailPageViewController()
        let router = DetailPageRouter()
        let viewModel = DetailPageViewModel()
        viewModel.view = viewController
        viewModel.router = router
        viewModel.searchService = injection.inject(SearchServiceProtocol.self)
        router.viewController = viewController
        viewController.output = viewModel
        viewModel.moduleOutput = configuration?(viewModel)
        return viewController
    }
}
