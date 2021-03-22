//
//  Inject.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Swinject

enum Inject {
    static var depContainer: Container = buildDefaultDepContainer()
    static func buildDefaultDepContainer() -> Container {
        let container = Container()
        return container
            .registerModules()
            .registerCoordinators()
    }
}

extension Container {
    
    func registerModules() -> Self {
        register(MainPageModuleAssembly.self) { _ in
            MainPageModuleAssembly(injection: self)
        }
        return self
    }
    
    func registerCoordinators() -> Self {
        self.register(SetupCoordinating.self) { (_: Resolver, window: UIWindow) in
            SetupCoordinator(window: window, injection: self)
        }
        return self
    }
}
