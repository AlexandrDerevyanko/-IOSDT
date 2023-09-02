
import UIKit

protocol ProfileCoordinatorProtocol {
    func pushProfileViewController(user: User, isUser: Bool)
    func pushSignupViewController()
    func popViewController()
    func pushUsersViewController(viewController: UIViewController)
    func pushPhotosViewController(user: User, isCurrentUser: Bool)
    func pushNewPostViewController(user: User, post: Post?, delegate: ProfileDelegate?)
    func pushSettingsViewController(user: User, isChangePassword: Bool)
    func pushCommentsViewController(user: User, post: Post)
}

class ProfileCoordinator: ProfileCoordinatorProtocol {
    var navigationController: UINavigationController?
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    var user = CoreDataManeger.defaulManager.user
    
    func pushProfileViewController(user: User, isUser: Bool) {
        let viewControllerToPush = ProfileViewController(user: user, isUser: isUser)
        viewControllerToPush.coordinator = self
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushSignupViewController() {
        let viewControllerToPush = SignupViewController()
        viewControllerToPush.signUpDelegate = MyLoginFactory().makeCheckerService()
        viewControllerToPush.coordinator = self
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func pushUsersViewController(viewController: UIViewController) {
        let viewControllerToPush = viewController
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushPhotosViewController(user: User, isCurrentUser: Bool) {
        let viewControllerToPush = PhotosViewController(user: user, isCurrentUser: isCurrentUser)
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushNewPostViewController(user: User, post: Post?, delegate: ProfileDelegate?) {
        let viewControllerToPush = NewPostViewController(user: user)
        viewControllerToPush.post = post
        viewControllerToPush.delegate = delegate
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushSettingsViewController(user: User, isChangePassword: Bool) {
        let viewControllerToPush = SettingsViewController(user: user, isChangePassword: isChangePassword)
        viewControllerToPush.coordinator = self
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func pushCommentsViewController(user: User, post: Post) {
        let viewControllerToPush = CommentsViewController(post: post, user: user)
        viewControllerToPush.coordinator = self
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
}
