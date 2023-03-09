//
//  LogInViewModel.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 24.02.2023.
//

protocol LogInViewModelProtocol: ViewModelProtocol{
    func pressed(viewInput: LogInViewModel.ViewInput)
}

class LogInViewModel: LogInViewModelProtocol {
    
    enum ViewInput {
        case logInButtonPressed(User)
    }
    
    weak var coordinator: ProfileCoordinator?
    
    func pressed(viewInput: ViewInput) {
        switch viewInput {
        case let .logInButtonPressed(user):
            coordinator?.pushProfileViewController(forUser: user)
        }
    }

}
