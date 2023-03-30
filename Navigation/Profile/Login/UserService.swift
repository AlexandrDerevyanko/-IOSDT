//
//  UserService.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 02.02.2023.
//

import UIKit

enum Autorization {
    case logIn
    case signUp
}

protocol LoginFactoryProtocol {
    func makeCheckerService() -> LoginInspector
}

struct MyLoginFactory: LoginFactoryProtocol {
    func makeCheckerService() -> LoginInspector {
        LoginInspector()
    }
}

protocol LoginDelegateProtocol {
    func logIn(logIn: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?) -> Void)
    func signUp(email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?) -> Void)
}

struct LoginInspector: LoginDelegateProtocol {
    func logIn(logIn: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?) -> Void) {
        CheckerService().checkCredentials(email: logIn, password: password) { autorizationData, autorizattionError in
            completion(autorizationData, autorizattionError)
        }
    }
    func signUp(email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?) -> Void) {
        CheckerService().signUp(email: email, password: password, passwordConfirmation: passwordConfirmation) { autorizationData, autorizattionError in
            completion(autorizationData, autorizattionError)
        }
    }
}


protocol CheckerServiceProtocol {
    func checkCredentials(email: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?) -> Void)
    func signUp(email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?) -> Void)
}

class CheckerService: CheckerServiceProtocol {
    init() {}
    func checkCredentials(email: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?) -> Void) {
        guard let mail = email, mail != "", let pass = password, pass != "" else {
            completion(nil, .emptyPasswordOrEmail)
            return
        }
        
        let users = RealmManager.defaultManager.users
        if users.isEmpty {
            completion(nil, .invalidPassword)
        } else {
            let user = users[0]
            if user.email == mail, user.password == pass {
                print(456)
                RealmManager.defaultManager.logIn(user: user)
                completion(.logIn, nil)
            } else {
                print(123)
                completion(nil, .invalidPassword)
            }
        }
        
//        Auth.auth().signIn(withEmail: mail, password: pass) { authDataResult, error in
//            if error != nil {
//                completion(nil, .invalidPassword)
//                return
//            }
//            if authDataResult?.user != nil {
//                completion(.logIn, nil)
//            } else {
//                completion(nil, .unexpected)
//                return
//            }
//        }
    }
    
    func signUp(email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?) -> Void) {
        guard let mail = email, mail != "", let pass = password, pass != "", let passConf = passwordConfirmation, passConf != "" else {
            completion(nil, .emptyPasswordOrEmail)
            return
        }
        
        if pass != passConf {
            completion(nil, .mismatchPassword)
            return
        }
        RealmManager.defaultManager.addUser(email: mail, password: pass, isLogIn: true)
        RealmManager.defaultManager.reloadFolders()
        completion(.signUp, nil)
//        Auth.auth().createUser(withEmail: mail, password: pass) { authDataResult, error in
//            if let error = error {
//                print(error.localizedDescription)
//                let err = error as NSError
//                
//                switch err.code {
//                case AuthErrorCode.emailAlreadyInUse.rawValue:
//                    completion(nil, .emailAlreadyInUse)
//                case AuthErrorCode.invalidEmail.rawValue:
//                    completion(nil, .invalidEmail)
//                case AuthErrorCode.weakPassword.rawValue:
//                    completion(nil, .weakPassword)
//                default:
//                    print(error.localizedDescription)
//                }
//            } else {
//                completion(.signUp, nil)
//            }
//        }
    }
}

class User {
    var logIn: String
    var fullName: String
    var avatar: UIImage
    var status: String
    init(logIn: String, fullName: String, avatar: UIImage, status: String) {
        self.logIn = logIn
        self.fullName = fullName
        self.avatar = avatar
        self.status = status
    }
}
