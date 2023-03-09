//
//  LogInCoordinator.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 24.02.2023.
//

import UIKit

final class ProfileCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType

    private let factory: AppFactory

    private(set) var module: Module?
    private(set) var childCoordinators: [Coordinatable] = []

    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }

    func start() -> UIViewController {
        let module = factory.makeModule(ofType: moduleType)
        let viewController = module.view
        viewController.tabBarItem = moduleType.tabBarItem
        (module.viewModel as? LogInViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func pushProfileViewController(forUser user: User) {
        
        let profileModule = { [self] in
            let viewModel = ProfileViewModel()
            let view = ProfileViewController(viewModel: viewModel, user: user)
            return Module(moduleType: moduleType, viewModel: viewModel, view: view)
        }
        let module = profileModule()
        (module.viewModel as? ProfileViewModel)?.coordinator = self
        let viewController = module.view
        (self.module?.view as? UINavigationController)?.pushViewController(viewController, animated: true)
    }
    
    func pushPhotosViewController() {
        let viewControllerToPush = PhotosViewController()
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)
    }
}
