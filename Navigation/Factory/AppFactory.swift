
import UIKit

final class AppFactory {

    func makeModule(ofType moduleType: Module.ModuleType) -> Module {
        switch moduleType {
        case .profile:
            let viewModel = LoginViewModel()
            let VC = LoginViewController()
            VC.logInDelegate = MyLoginFactory().makeCheckerService()
            let view = UINavigationController(rootViewController: VC)
            return Module(moduleType: moduleType, viewModel: viewModel, view: view)
        case .feed:
            let viewModel = FeedViewModel()
            let view = UINavigationController(rootViewController: FeedViewController())
            return Module(moduleType: moduleType, viewModel: viewModel, view: view)
        }
    }
}
