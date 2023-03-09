//
//  ProfileViewModel.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 21.02.2023.
//

protocol ProfileViewModelProtocol: ViewModelProtocol{
    func pressed(viewInput: ProfileViewModel.ViewInput)
    func backgroundView(viewInput: ProfileViewModel.BackgroundViewInput)
}

class ProfileViewModel: ProfileViewModelProtocol {
    
    enum ViewInput {
        case collectionViewPressed
    }
    
    enum BackgroundViewInput {
        case timer
    }
    
    weak var coordinator: ProfileCoordinator?
    
    func pressed(viewInput: ViewInput) {
        switch viewInput {
        case .collectionViewPressed:
            coordinator?.pushPhotosViewController()
        }
    }
    
    func backgroundView(viewInput: BackgroundViewInput) {
        switch viewInput {
        case .timer:
            print("1")
        }
    }

}
