//
//  SetupCoordinator.swift
//  SkyEngTranslate
//
//  Created by Turan Assylkhan on 22.03.2021.
//

import UIKit

class SetupCoordinator: SetupCoordinating {
    
    // MARK: - Properties
    
    private let window: UIWindow
    private let injection: ModuleInjecting
    private let navigationController: UINavigationController
    
    // MARK: - Initialization
    
    init(window: UIWindow, injection: ModuleInjecting) {
        self.window = window
        self.injection = injection
        navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - RegistrationCoordinating
    
    func start() {
        guard
            let mainViewController = injection
                .inject(MainPageModuleAssembly.self)?
                .assemble()
            else {
                return
        }
        navigationController.setViewControllers([mainViewController], animated: false)
        
        let transition: () -> Void = { self.window.rootViewController = self.navigationController }
        if let previousViewController = window.rootViewController {
            UIView.transition(with: window,
                              duration: 0.5,
                              options: .transitionFlipFromLeft,
                              animations: transition)
            previousViewController.dismiss(animated: false) {
                previousViewController.view.removeFromSuperview()
            }
        } else {
            transition()
        }
    }
}
