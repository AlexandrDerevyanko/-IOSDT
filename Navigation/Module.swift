import UIKit

protocol ViewModelProtocol: AnyObject {}

struct Module {
    enum ModuleType {
        case login
        case feed
    }

    let moduleType: ModuleType
    let viewModel: ViewModelProtocol
    let view: UIViewController
}

extension Module.ModuleType {
    var tabBarItem: UITabBarItem {
        switch self {
        case .login:
            return UITabBarItem(title: NSLocalizedString("profile-tabbar-localizable", comment: ""), image: .add, tag: 0)
        case .feed:
            return UITabBarItem(title: NSLocalizedString("feed-tabbar-localizable", comment: ""), image: .checkmark, tag: 1)
        }
    }
}
