import Foundation

protocol LoginViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((LoginViewModel.State) -> Void)? { get set }
    func updateState(viewInput: LoginViewModel.ViewInput)
}

final class LoginViewModel: LoginViewModelProtocol {
    enum State {
        case waiting
        case login
        case signup
    }

    enum ViewInput {
        case loginButtonPressed
        case signupButtonPressed
    }

    weak var coordinator: LoginCoordinator?
    var onStateDidChange: ((State) -> Void)?

    private(set) var state: State = .waiting {
        didSet {
            onStateDidChange?(state)
        }
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .loginButtonPressed:
            state = .waiting
//            networkService.loadBooks { [weak self] result in
//                switch result {
//                case .success(let books):
//                    self?.state = .loaded(books: books)
//                case .failure(let error):
//                    self?.state = .error(error)
//                }
//            }
        case .signupButtonPressed:
            coordinator?.pushSignupViewController()
        }
    }
}
