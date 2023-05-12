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
        case verify
    }

    weak var coordinator: LoginCoordinator?
    var onStateDidChange: ((State) -> Void)?
    var logInDelegate: LoginDelegateProtocol?
    var biometricIDAuth = BiometricIDAuth()

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
            
        case .verify:
            
            biometricIDAuth.canEvaluate { (canEvaluate, biometricType, canEvaluateError) in
                guard canEvaluate else {
                    state = .verificationRejected("Error", canEvaluateError?.localizedDescription ?? "Face ID/Touch ID may not be configured", "Ok")
                    return
                }
                
                switch biometricType {
                case .faceID:
                    state = .setImage(UIImage(systemName: "faceid")?.withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage())
                case .touchID:
                    state = .setImage(UIImage(systemName: "touchid")?.withTintColor(.white, renderingMode: .alwaysOriginal) ?? UIImage())
                case .none:
                    ()
                case .unknown:
                    ()
                }
                    
                biometricIDAuth.evaluate { (success, error) in
                    guard success else {
                        self.state = .verificationRejected("Error", error?.localizedDescription ?? "Face ID/Touch ID may not be configured", "Ok")
                        return
                    }
                    self.state = .verificationAccepted("Success", "You have a free pass, now", "Ok")
                }
            }
        }
    }
}
