import Foundation
import UIKit

protocol ProfileViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((ProfileViewModel.State) -> Void)? { get set }
    func updateState(viewInput: ProfileViewModel.ViewInput)
}

final class ProfileViewModel: ProfileViewModelProtocol {
    enum State {
        case waiting
        case setStatus(String)
        case newPost
        case setImage(UIImage)
        case tableViewCellPressed
    }

    enum ViewInput {
        case setStatus(status: String, user: User)
        case newPost
        case setImage(image: UIImage)
        case tableViewCellPressed
        case likePost(post: Post)
        case subscribe(authorizedUser: User, subscriptionUser: User)
    }

//    weak var coordinator: ProfileCoordinator?
    var onStateDidChange: ((State) -> Void)?
    private var biometricIDAuth = BiometricIDAuth()

    private(set) var state: State = .waiting {
        didSet {
            onStateDidChange?(state)
        }
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {

        case let .setStatus(status, user):
            CoreDataManeger.defaulManager.updateUserStatus(user: user, newStatus: status)
        case .newPost:
            ()
        case .setImage:
            ()
        case .tableViewCellPressed:
            ()
        case let .likePost(post):
            CoreDataManeger.defaulManager.favoritePost(post: post, isFavorite: true)
        case let .subscribe(authorizedUser, subscriptionUser):
            CoreDataManeger.defaulManager.addSubscription(authorizedUser: authorizedUser, subscriptionUser: subscriptionUser)
            CoreDataManeger.defaulManager.addSubscriber(authorizedUser: subscriptionUser, subscriberUser: authorizedUser)
        }
        
    }
}
