//
//  RealmManager.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 29.03.2023.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let defaultManager = RealmManager()
    
    var users: [RealmUser] = []
    
    init() {
        let config = Realm.Configuration(schemaVersion: 2)
        Realm.Configuration.defaultConfiguration = config
        reloadFolders()
    }
    
    func reloadFolders() {
        let realm = try! Realm()
        users = Array(realm.objects(RealmUser.self))
    }
    
    func addUser(email: String, password: String, isLogIn: Bool) {
        let user = RealmUser(email: email, password: password, isLogIn: isLogIn)
        let realm = try! Realm()
        try! realm.write({
            realm.add(user)
        })
    }
    
    func deleteUser(user: RealmUser) {
        let realm = try! Realm()
        try! realm.write({
            realm.delete(user)
        })
    }
    
    func logIn(user: RealmUser) {
        let realm = try! Realm()
        try! realm.write({
            user.isLogIn = true
        })
    }
    
    func logOut(user: RealmUser) {
        let realm = try! Realm()
        try! realm.write({
            user.isLogIn = false
        })
    }
    
}
