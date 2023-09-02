
import UIKit

class TabBarController: UITabBarController {
    
    var logInTabNavigationController: UINavigationController!
    var feedTabNavigationController: UINavigationController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let loginVC = LoginViewController()
        loginVC.logInDelegate = MyLoginFactory().makeCheckerService()
        logInTabNavigationController = UINavigationController.init(rootViewController: loginVC)
        feedTabNavigationController = UINavigationController.init(rootViewController: FeedViewController())

        self.viewControllers = [logInTabNavigationController, feedTabNavigationController]
        
        let firstItem = UITabBarItem(title: "Профиль",
                                 image: UIImage(systemName: "person"), tag: 0)
        let secondItem = UITabBarItem(title: "Новости", image: UIImage(systemName: "newspaper"), tag: 1)

        logInTabNavigationController.tabBarItem = firstItem
        feedTabNavigationController.tabBarItem = secondItem
        
        UITabBar.appearance().tintColor = UIColor.createColor(lightMode: .systemBlue, darkMode: .white)
        UITabBar.appearance().backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        tabBar.isHidden = true
    }
    
}
