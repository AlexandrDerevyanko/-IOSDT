import UIKit

final class FeedCoordinator: ModuleCoordinatable {
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
        (module.viewModel as? FeedViewModel)?.coordinator = self
        self.module = module
        return viewController
    }
    
    func pushInfoViewController() {
        let networkService = NetworkService()
        let viewControllerToPush = InfoViewController(networkService: networkService)
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushPostViewController() {
        let viewControllerToPush = PostViewController()
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)
    }
    
}
