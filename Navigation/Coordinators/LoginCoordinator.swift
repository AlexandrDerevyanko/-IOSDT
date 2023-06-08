import UIKit

final class LoginCoordinator: ModuleCoordinatable {
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
        (module.viewModel as? LoginViewModel)?.coordinator = self
        self.module = module
        return viewController
    }

    func pushProfileViewController(user: User) {
        let viewModel = ProfileViewModel()
//        viewModel.coordinator = ProfileCoordinator(moduleType: moduleType, factory: factory)
        let viewControllerToPush = ProfileViewController(user: user, viewModel: viewModel, isUser: true)
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushSignupViewController() {
        let viewControllerToPush = SignupViewController()
        viewControllerToPush.signUpDelegate = MyLoginFactory().makeCheckerService()
        (module?.view as? UINavigationController)?.pushViewController(viewControllerToPush, animated: true)
    }
}
