
import UIKit
import CoreData

class ProfileViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var coreDataManager = CoreDataManeger.defaulManager
    var coordinator: ProfileCoordinatorProtocol?
    var user: User
    var isCurrentUser: Bool
    var subscribers: [Subscriber] {
        return subscribersFetchResultsController?.fetchedObjects ?? []
    }
    var subscriptions: [Subscription] {
        return subscriptionsFetchResultsController?.fetchedObjects ?? []
    }
//    var likes: [Like] {
//        return likesFetchResultsController?.fetchedObjects ?? []
//    }
    
    var headerView: UIView {
        return isCurrentUser ? ProfileHeaderView(delegate: self, user: user, subscribers: subscribers, subscriptions: subscriptions) : UserProfileView(delegate: self, user: user, subscribers: subscribers, subscriptions: subscriptions)
    }
        
    var likesFetchResultsController: NSFetchedResultsController<Like>?
    var postsFetchResultsController: NSFetchedResultsController<Post>?
    var subscriptionsFetchResultsController: NSFetchedResultsController<Subscription>?
    var subscribersFetchResultsController: NSFetchedResultsController<Subscriber>?
    var photosFetchResultsController: NSFetchedResultsController<Photo>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        tableView.register(FirstSectionTableViewCell.self, forCellReuseIdentifier: "FirstSectionCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "SecondSectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    init(user: User, isUser: Bool) {
        self.user = user
        self.isCurrentUser = isUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubscriptionsFetchResultsController()
        initSubscribersFetchResultsController()
        initPostsFetchResultsController()
        initPhotosFetchResultsController()
        setupUI()
        let logOutButton = UIBarButtonItem(title: NSLocalizedString("logOut-button-profileVC-localizable", comment: ""), style: .plain, target: self, action: #selector(logOutButtonPressed))
        logOutButton.tintColor = UIColor.createColor(lightMode: .systemBlue, darkMode: .white)
        isCurrentUser ? navigationItem.leftBarButtonItem = logOutButton : ()
        let settingsButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(settingsButtonPressed))
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Профиль"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        view.addSubview(tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func initLikesFetchResultsController(post: Post) {
        let fetchRequest = Like.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "post == %@", post)
        likesFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        likesFetchResultsController?.delegate = self
        try? likesFetchResultsController?.performFetch()
    }
    
    func initPostsFetchResultsController() {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        postsFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        postsFetchResultsController?.delegate = self
        try? postsFetchResultsController?.performFetch()
    }
    
    func initSubscriptionsFetchResultsController() {
        let fetchRequest = Subscription.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        subscriptionsFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        subscriptionsFetchResultsController?.delegate = self
        try? subscriptionsFetchResultsController?.performFetch()
    }
    
    func initSubscribersFetchResultsController() {
        let fetchRequest = Subscriber.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        subscribersFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        subscribersFetchResultsController?.delegate = self
        try? subscribersFetchResultsController?.performFetch()
    }
    
    func initPhotosFetchResultsController() {
        let fetchRequest = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        photosFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        photosFetchResultsController?.delegate = self
        try? photosFetchResultsController?.performFetch()
    }
    
    @objc
    private func logOutButtonPressed() {
//        coreDataManager.user = nil
        coreDataManager.deauthorization(user: user)
        tabBarController?.tabBar.isHidden = true
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func settingsButtonPressed() {
        coordinator?.pushSettingsViewController(user: user, isChangePassword: false)
    }
    
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        if section == 0 {
            let cell = headerView
            return cell
        }
        return nil

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 {
            return 1
        } else if section == 1 {
            return postsFetchResultsController?.fetchedObjects?.count ?? 0
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstSectionCell", for: indexPath) as? FirstSectionTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            
            cell.photos = photosFetchResultsController?.fetchedObjects

            return cell

        } else if indexPath.section == 1 {

            guard let cell = tableView.dequeueReusableCell(withIdentifier: "SecondSectionCell", for: indexPath) as? PostTableViewCell else {
                preconditionFailure("Error")
            }
            let postInCell = postsFetchResultsController?.fetchedObjects?[indexPath.row]
            cell.delegate = self
            cell.post = postInCell
            cell.setup()
            return cell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            
        return cell
        
    }
    
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return tableView.frame.width / 3.2
//        }
//        if indexPath.section == 1 {
//            return UITableView.automaticDimension
//        }
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                collectionViewPressed()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if indexPath.section == 1 {
            let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, complete in
                if let postInCell = self.postsFetchResultsController?.fetchedObjects?[indexPath.row] {
                    CoreDataManeger.defaulManager.deletePost(post: postInCell)
                    self.initPostsFetchResultsController()
                    tableView.reloadData()
                }
            }
            return UISwipeActionsConfiguration(actions: [action])
        } else {
            return nil
        }
        
        
    }
    
//    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.beginUpdates()
//    }
//
//    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
//        tableView.endUpdates()
//    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            ()
//            tableView.insertRows(at: [IndexPath(row: newIndexPath!.row, section: 1)], with: .automatic)
        case .delete:
//            tableView.deleteRows(at: [IndexPath(row: indexPath!.row, section: 1)], with: .automatic)
            tableView.reloadData()
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadData()
        @unknown default:
            tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 135
        }
        return UITableView.automaticDimension
    }
    
}

extension ProfileViewController: ProfileDelegate {
    
    func collectionViewPressed() {
        coordinator?.pushPhotosViewController(user: user, isCurrentUser: isCurrentUser)
    }
    
    func pushNewPostViewController() {
        coordinator?.pushNewPostViewController(user: user, post: nil, delegate: self)
    }
    
    func changePost(post: Post) {
        if isCurrentUser {
            coordinator?.pushNewPostViewController(user: user, post: post, delegate: self)
        }
    }
    
    func likePost(post: Post) {
        initLikesFetchResultsController(post: post)
        guard let likesArray: [Like] = likesFetchResultsController?.fetchedObjects, let authorizedUser = coreDataManager.user else { return }
        
        for i in likesArray {
            if i.login == authorizedUser.login {
                coreDataManager.deleteLike(postUUID: post.postID ?? UUID(), userLogin: authorizedUser.login ?? "")
                return
            }
        }
        coreDataManager.likePost(postUUID: post.postID ?? UUID(), userLogin: post.user?.login ?? "")
        
        
        
    }
    
    func setStatusButtonPressed(status: String, user: User) {
        coreDataManager.updateUserStatus(user: user, newStatus: status)
    }
    
    func subscribe(authorizedUser: User, subscriptionUser: User) {
        let usersArray = subscribers
        print(usersArray)
        for i in usersArray {
            if i.userSubscriber == authorizedUser {
                AlertManager.defaulManager.alert(title: "Ошибка", message: "Вы уже подписаны", okActionTitle: "Ок", showIn: self)
                return
            }
        }
        coreDataManager.subscribe(authorizedUser: authorizedUser, subscriptionUser: subscriptionUser)
    }
    
    func pushUsersViewController(post: Post?, subscribers: [Subscriber]?, subscriptions: [Subscription]?) {
        let usersVC = UsersViewController()
        if let post {
            usersVC.post = post
        } else if let subscribers {
            usersVC.subscribers = subscribers
        } else if let subscriptions {
            usersVC.subscriptions = subscriptions
        } else { return }
        
        coordinator?.pushUsersViewController(viewController: usersVC)
    }
    
    func pushCommentsViewController(post: Post) {
        coordinator?.pushCommentsViewController(user: coreDataManager.user ?? User(), post: post)
    }
    
}
