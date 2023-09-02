//
//  AppDelegate.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 06.11.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var localNotificationsService = LocalNotificationsService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let users = CoreDataManeger.defaulManager.users
        if users.count == 0 {

            
            CoreDataManeger.defaulManager.addUser(logIn: "corgi@gmail.com", password: "123456", fullName: "Corgi Cevin", avatar: UIImage(named: "corgi")?.pngData())
            CoreDataManeger.defaulManager.addUser(logIn: "corgi@gmail.com2", password: "123456", fullName: "Corgi Dexter", avatar: UIImage(named: "sadCorgi")?.pngData())
            CoreDataManeger.defaulManager.addUser(logIn: "corgi@gmail.com3", password: "123456", fullName: "Corgi Dexter", avatar: UIImage(named: "sadCorgi")?.pngData())
            CoreDataManeger.defaulManager.addUser(logIn: "corgi@gmail.com4", password: "123456", fullName: "Corgi Dexter", avatar: UIImage(named: "sadCorgi")?.pngData())
            CoreDataManeger.defaulManager.addUser(logIn: "corgi@gmail.com5", password: "123456", fullName: "Corgi Dexter", avatar: UIImage(named: "sadCorgi")?.pngData())
            
            var firstUser: User {
                return CoreDataManeger.defaulManager.getUser(login: "corgi@gmail.com", context: CoreDataManeger.defaulManager.persistentContainer.viewContext) ?? User()
            }
            var secondUser: User {
                return CoreDataManeger.defaulManager.getUser(login: "corgi@gmail.com2", context: CoreDataManeger.defaulManager.persistentContainer.viewContext) ?? User()
            }
            
            CoreDataManeger.defaulManager.addPost(text: "Test post", image: UIImage(named: "3")?.pngData(), for: firstUser)
            CoreDataManeger.defaulManager.addPost(text: "Test post", image: UIImage(named: "4")?.pngData(), for: firstUser)
            CoreDataManeger.defaulManager.addPost(text: "Test post", image: UIImage(named: "1")?.pngData(), for: secondUser)
            CoreDataManeger.defaulManager.addPost(text: "Test post", image: UIImage(named: "2")?.pngData(), for: secondUser)
            
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}
