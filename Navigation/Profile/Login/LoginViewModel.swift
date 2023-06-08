import Foundation
import UIKit

protocol LoginViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LoginViewModel.ViewInput)
}

final class LoginViewModel: LoginViewModelProtocol {
    enum State {
        case waiting
        case alert(AutorizationErrors)
        case verificationRejected(String, String, String)
        case setImage(UIImage)
        case verificationAccepted(String, String, String)
    }

    enum ViewInput {
        case loginButtonPressed(email: String, password: String)
        case signupButtonPressed
        case checkUser(user: User)
    }

    weak var coordinator: LoginCoordinator?
    var onStateDidChange: ((State) -> Void)?
    var logInDelegate: LoginDelegateProtocol?
    private var biometricIDAuth = BiometricIDAuth()

    private(set) var state: State = .waiting {
        didSet {
            onStateDidChange?(state)
        }
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case let .loginButtonPressed(email, password):
            
            logInDelegate?.logIn(logIn: email, password: password, completion: { [self] data, error, user  in
                if let error = error {
                    state = .alert(error)
                    return
                }
                guard let user = user else {
                    state = .alert(.invalidPassword)
                    return
                }
                CoreDataManeger.defaulManager.authorization(user: user)
                CoreDataManeger.defaulManager.user = user
                coordinator?.pushProfileViewController(user: user)
            })
            
        case .signupButtonPressed:
            
            coordinator?.pushSignupViewController()
            
        case let .checkUser(user):
            coordinator?.pushProfileViewController(user: user)
        }
    }
}
