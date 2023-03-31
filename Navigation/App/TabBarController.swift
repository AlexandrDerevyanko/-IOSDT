//
//  TabBarController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 31.03.2023.
//

import UIKit

class TabBarController: UITabBarController {
    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        setupUILogOutStatus()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    var feedTabNavigationController: UINavigationController!
    var logInTabNavigationController: UINavigationController!
    var favoritesTabNavigationController: UINavigationController!
    let loginVC = LoginViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        loginVC.logInDelegate = MyLoginFactory().makeCheckerService()
        feedTabNavigationController = UINavigationController.init(rootViewController: FeedViewController())
        logInTabNavigationController = UINavigationController.init(rootViewController: loginVC)
        favoritesTabNavigationController = UINavigationController.init(rootViewController: PostViewController())
    }
    
    func setupUILogOutStatus() {

        self.viewControllers = [feedTabNavigationController, logInTabNavigationController]
        
        let firstItem = UITabBarItem(title: "Feed",
                                 image: UIImage(systemName: "square.and.arrow.up"), tag: 0)
        let secondItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "tray.and.arrow.up"), tag: 1)
        
        feedTabNavigationController.tabBarItem = firstItem
        logInTabNavigationController.tabBarItem = secondItem
        
    }
    
    func setupUILogInStatus() {

        self.viewControllers = [logInTabNavigationController, favoritesTabNavigationController]

        let firstItem = UITabBarItem(title: "Profile",
                                 image: UIImage(systemName: "square.and.arrow.up"), tag: 3)
        let secondItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "tray.and.arrow.up"), tag: 4)

        logInTabNavigationController.tabBarItem = firstItem
        favoritesTabNavigationController.tabBarItem = secondItem
        
        UITabBar.appearance().tintColor = .black
        UITabBar.appearance().backgroundColor = .systemGray6

    }
    
    
}
