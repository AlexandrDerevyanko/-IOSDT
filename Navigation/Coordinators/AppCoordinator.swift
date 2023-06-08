
import UIKit

final class AppCoordinator: Coordinatable {
    private(set) var childCoordinators: [Coordinatable] = []

    private let factory: AppFactory

    init(factory: AppFactory) {
        self.factory = factory
    }

    func start() -> UIViewController {
        let loginCoordinator = LoginCoordinator(moduleType: .login, factory: factory)
        let feedCoordinator = FeedCoordinator(moduleType: .feed, factory: factory)

        let appTabBarController = AppTabBarController(viewControllers: [
            loginCoordinator.start(),
            feedCoordinator.start()
        ])

        addChildCoordinator(loginCoordinator)
        addChildCoordinator(feedCoordinator)

        return appTabBarController
    }

    func addChildCoordinator(_ coordinator: Coordinatable) {
        guard !childCoordinators.contains(where: { $0 === coordinator }) else {
            return
        }
        childCoordinators.append(coordinator)
    }

    func removeChildCoordinator(_ coordinator: Coordinatable) {
        childCoordinators = childCoordinators.filter { $0 === coordinator }
    }
}
