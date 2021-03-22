//
//  SceneDelegate.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate, RootUIControllerType {
    
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.makeKeyAndVisible()
        self.window = window
        setupRootViewController()
    }

    func setupRootViewController() {
        guard
            let window = window,
            let setupCoordinator = Inject.depContainer
                .inject(SetupCoordinating.self, argument: window)
            else {
                return
        }
        setupCoordinator.start()
    }
}

