//
//  Inject.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import Alamofire
import Moya
import Swinject

enum Inject {
    static var depContainer: Container = buildDefaultDepContainer()
    static func buildDefaultDepContainer() -> Container {
        let container = Container()
        return container
            .registerNetworking()
            .registerServices()
            .registerModules()
            .registerCoordinators()
    }
}

extension Container {
    
    func registerModules() -> Self {
        register(MainPageModuleAssembly.self) { _ in
            MainPageModuleAssembly(injection: self)
        }
        register(DetailPageModuleAssembly.self) { _ in
            DetailPageModuleAssembly(injection: self)
        }
        return self
    }
    
    func registerNetworking() -> Self {
        if let reachabilityManager = NetworkReachabilityManager() {
            register(NetworkReachabilityChecking.self) { _ in reachabilityManager }
        }
        return registerMoyaPlugins()
    }
    
    func registerMoyaPlugins() -> Self {
        register(NetworkLoggerPlugin.self) { _ in
            NetworkLoggerPlugin(configuration: NetworkLoggerPluginConfig.prettyLogging)
        }
        return self
    }
    
    func registerServices() -> Self {
        
        func resolveDefaultPlugins(resolver: Resolver) -> [PluginType] {
            let optionalPlugins: [PluginType?] = [
                resolver.resolve(NetworkLoggerPlugin.self)]
            return optionalPlugins.compactMap { $0 }
        }
        
        register(SearchServiceProtocol.self) { (res: Resolver) in
            let generalProvider = NetworkDataProvider<SearchTarget>(
                networkReachibilityChecker: res.resolve(NetworkReachabilityChecking.self),
                plugins: resolveDefaultPlugins(resolver: res))
            return SearchService(dataProvider: generalProvider)
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
