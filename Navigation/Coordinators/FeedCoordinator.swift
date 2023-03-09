//
//  FeedListCoordinator.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 17.02.2023.
//

import UIKit

final class FeedCoordinator: ModuleCoordinatable {
    let moduleType: Module.ModuleType

    private let factory: AppFactory

    private(set) var childCoordinators: [Coordinatable] = []
    private(set) var module: Module?

    init(moduleType: Module.ModuleType, factory: AppFactory) {
        self.moduleType = moduleType
        self.factory = factory
    }

    func start() -> UIViewController {
        let module = factory.makeModule(ofType: moduleType)
        let viewController = module.view
        viewController.tabBarItem = moduleType.tabBarItem
        (module.viewModel as? FeedViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func pushPostViewController() {
        let viewControllerToPush = PostViewController()
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushInfoViewController() {
        let viewControllerToPush = InfoViewController()
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)
    }
}
