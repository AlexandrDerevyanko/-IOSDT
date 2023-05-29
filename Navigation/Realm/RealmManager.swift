////
////  RealmManager.swift
////  Navigation
////
////  Created by Aleksandr Derevyanko on 29.03.2023.
////
//
//import Foundation
//import RealmSwift
//
//class RealmManager {
//    
//    static let defaultManager = RealmManager()
//    
//    var users: [RealmUser] = []
//    
//    init() {
//        let config = Realm.Configuration(schemaVersion: 2)
//        Realm.Configuration.defaultConfiguration = config
//        reloadFolders()
//    }
//    
//    func reloadFolders() {
//        do {
//            let realm = try Realm()
//            users = Array(realm.objects(RealmUser.self))
//        } catch {
//            print(error)
//        }
//
//    }
//    
//    func addUser(email: String, password: String, isLogIn: Bool) {
//        let user = RealmUser(email: email, password: password, isLogIn: isLogIn)
//        
//        do {
//            let realm = try Realm()
//            try realm.write({
//                realm.add(user)
//            })
//        } catch {
//            print(error)
//        }
//
//    }
//    
//    func deleteUser(user: RealmUser) {
//        do {
//            let realm = try Realm()
//            try realm.write({
//                realm.delete(user)
//            })
//        } catch {
//            print(error)
//        }
//    }
//    
//    func logIn(user: RealmUser) {
//        do {
//            let realm = try Realm()
//            try realm.write({
//                user.isLogIn = true
//            })
//        } catch {
//            print(error)
//        }
//    }
//    
//    func logOut(user: RealmUser) {
//        do {
//            let realm = try Realm()
//            try realm.write({
//                user.isLogIn = false
//            })
//        } catch {
//            print(error)
//        }
//    }
//}
