////
////  TabBarController.swift
////  Navigation
////
////  Created by Aleksandr Derevyanko on 31.03.2023.
////
//
//import UIKit
//
//class TabBarController: UITabBarController {
//    
//    var locationTabNavigationController: UINavigationController!
//    var logInTabNavigationController: UINavigationController!
//    var favoritesTabNavigationController: UINavigationController!
//    let loginVC = LoginViewController()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//    }
//    
//    func setupUI() {
//        
//        loginVC.logInDelegate = MyLoginFactory().makeCheckerService()
//        locationTabNavigationController = UINavigationController.init(rootViewController: LocationViewController())
//        logInTabNavigationController = UINavigationController.init(rootViewController: loginVC)
//        favoritesTabNavigationController = UINavigationController.init(rootViewController: FavoritesViewController())
//
//        self.viewControllers = [logInTabNavigationController, locationTabNavigationController, favoritesTabNavigationController]
//        
//        let firstItem = UITabBarItem(title: NSLocalizedString("location-tabbar-localizable", comment: ""),
//                                 image: UIImage(systemName: "location"), tag: 0)
//        let secondItem = UITabBarItem(title: NSLocalizedString("profile-tabbar-localizable", comment: ""), image: UIImage(systemName: "person"), tag: 1)
//        let thirdItem = UITabBarItem(title: NSLocalizedString("favorites-tabbar-localizable", comment: ""), image: UIImage(systemName: "star"), tag: 2)
//        
//        locationTabNavigationController.tabBarItem = firstItem
//        logInTabNavigationController.tabBarItem = secondItem
//        favoritesTabNavigationController.tabBarItem = thirdItem
//        
//        UITabBar.appearance().tintColor = UIColor.createColor(lightMode: .systemBlue, darkMode: .white)
//        UITabBar.appearance().backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
//    }
//    
//}
