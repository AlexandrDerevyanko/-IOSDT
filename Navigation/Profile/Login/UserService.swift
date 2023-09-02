
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
    func logIn(logIn: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?, _ user: User?) -> Void)
    func signUp(fullName: String?, email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ isAutorization: Bool?, _ autorizattionError: AutorizationErrors?) -> Void)
}

struct LoginInspector: LoginDelegateProtocol {
    func logIn(logIn: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?, _ user: User?) -> Void) {
        CheckerService().checkCredentials(email: logIn, password: password) { autorizationData, autorizattionError, user in
            completion(autorizationData, autorizattionError, user)
        }
    }
    func signUp(fullName: String?, email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ isAutorization: Bool?, _ autorizattionError: AutorizationErrors?) -> Void) {
        CheckerService().signUp(fullName: fullName, email: email, password: password, passwordConfirmation: passwordConfirmation) { isAutorization, autorizattionError in
            completion(isAutorization, autorizattionError)
        }
    }
}


protocol CheckerServiceProtocol {
    func checkCredentials(email: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?, _ user: User?) -> Void)
    func signUp(fullName: String?, email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ isAutorization: Bool?, _ autorizattionError: AutorizationErrors?) -> Void)
}

class CheckerService: CheckerServiceProtocol {
    
    init() {}
    func checkCredentials(email: String?, password: String?, completion: @escaping (_ autorizationData: Autorization?, _ autorizattionError: AutorizationErrors?, _ user: User?) -> Void) {
        guard let mail = email, mail != "", let pass = password, pass != "" else {
            completion(nil, .empty, nil)
            return
        }
        CoreDataManeger.defaulManager.reloadUsers()
        let users = CoreDataManeger.defaulManager.users
        if users.isEmpty {
            completion(nil, .invalidPassword, nil)
            return
        }
        var counter = 0
        for i in users {
            counter += 1
            if mail == i.login, pass == i.password {
                completion(nil, nil, i)
                return
            }
        }
        completion(nil, .invalidPassword, nil)

    }
    
    func signUp(fullName: String?, email: String?, password: String?, passwordConfirmation: String?, completion: @escaping (_ isAutorization: Bool?, _ autorizattionError: AutorizationErrors?) -> Void) {
        guard let mail = email, mail != "", let pass = password, pass != "", let passConf = passwordConfirmation, passConf != "", let name = fullName, name != "" else {
            completion(nil, .empty)
            return
        }
        
        if pass != passConf {
            completion(nil, .mismatchPassword)
            return
        }
        let users = CoreDataManeger.defaulManager.users
        for i in users {
            if i.login == mail {
                completion(nil, .emailAlreadyInUse)
                return
            }
        }
        CoreDataManeger.defaulManager.addUser(logIn: mail, password: pass, fullName: name, avatar: nil)
        completion(true, nil)
    }
}
