
import UIKit

final class AppFactory {

    func makeModule(ofType moduleType: Module.ModuleType) -> Module {
        switch moduleType {
        case .login:
            let viewModel = LoginViewModel()
            viewModel.logInDelegate = MyLoginFactory().makeCheckerService()
            let VC = LoginViewController(viewModel: viewModel)
//            VC.logInDelegate = MyLoginFactory().makeCheckerService()
            let view = UINavigationController(rootViewController: VC)
            return Module(moduleType: moduleType, viewModel: viewModel, view: view)
        case .feed:
            let viewModel = FeedViewModel()
            let view = UINavigationController(rootViewController: FeedViewController(viewModel: viewModel))
            return Module(moduleType: moduleType, viewModel: viewModel, view: view)
        }
    }
}
