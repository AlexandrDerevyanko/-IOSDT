
import UIKit
import CoreData

protocol ProfileDelegate: AnyObject {
    func pushNewPostViewController()
    func changePost(post: Post)
    func likePost(post: Post)
    func setStatusButtonPressed(status: String, user: User)
    func subscribe(authorizedUser: User, subscriptionUser: User)
    func subscribersButtonPressed()
    func subscriptionsButtonPressed()
    
}

class ProfileViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var user: User
    var isCurrentUser: Bool
    
    var headerView: UIView {
        return isCurrentUser ? ProfileHeaderView(delegate: self, user: user, subscribers: subscribersFetchResultsController?.fetchedObjects?.count ?? 100, subscriptions: subscriptionsFetchResultsController?.fetchedObjects?.count ?? 100) : UserProfileView(delegate: self, user: user, subscribers: subscribersFetchResultsController?.fetchedObjects?.count ?? 100, subscriptions: subscriptionsFetchResultsController?.fetchedObjects?.count ?? 100)
    }
    
    private let viewModel: ProfileViewModelProtocol
    
    var postsFetchResultsController: NSFetchedResultsController<Post>?
    var subscriptionsFetchResultsController: NSFetchedResultsController<Subscription>?
    var subscribersFetchResultsController: NSFetchedResultsController<Subscriber>?
    
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
    
    init(user: User, viewModel: ProfileViewModelProtocol, isUser: Bool) {
        self.user = user
        self.isCurrentUser = isUser
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let logOutButton = UIBarButtonItem(title: NSLocalizedString("logOut-button-profileVC-localizable", comment: ""), style: .plain, target: self, action: #selector(pushLogOutButton))
        logOutButton.tintColor = UIColor.createColor(lightMode: .systemBlue, darkMode: .white)
        isCurrentUser ? navigationItem.leftBarButtonItem = logOutButton : ()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = NSLocalizedString("profile-tabbar-localizable", comment: "")
        initSubscriptionsFetchResultsController()
        initSubscribersFetchResultsController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initPostsFetchResultsController()
        tableView.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
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
    
    @objc
    private func pushLogOutButton() {
        CoreDataManeger.defaulManager.user = nil
        CoreDataManeger.defaulManager.deauthorization(user: user)
        navigationController?.popViewController(animated: true)
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
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, complete in
            if let postInCell = self.postsFetchResultsController?.fetchedObjects?[indexPath.row] {
                CoreDataManeger.defaulManager.deletePost(post: postInCell)
                self.initPostsFetchResultsController()
                tableView.reloadData()
            }
        }

        return UISwipeActionsConfiguration(actions: [action])
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            tableView.insertRows(at: [IndexPath(row: newIndexPath!.row, section: 1)], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [IndexPath(row: indexPath!.row, section: 1)], with: .automatic)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            tableView.reloadData()
        @unknown default:
            tableView.reloadData()
        }
        self.tableView.reloadData()
    }
    
}

extension ProfileViewController: ProfileDelegate {
    
    func collectionViewPressed() {
        let photosVC = PhotosViewController()
        navigationController?.pushViewController(photosVC, animated: true)
    }
    
    func pushNewPostViewController() {
        let newPostVC = NewPostViewController(user: user)
        newPostVC.delegate = self
        navigationController?.pushViewController(newPostVC, animated: true)
    }
    
    func changePost(post: Post) {
        let postVC = NewPostViewController(post: post, user: user)
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    func likePost(post: Post) {
        viewModel.updateState(viewInput: .likePost(post: post))
    }
    
    func setStatusButtonPressed(status: String, user: User) {
        viewModel.updateState(viewInput: .setStatus(status: status, user: user))
    }
    
    func subscribe(authorizedUser: User, subscriptionUser: User) {
        viewModel.updateState(viewInput: .subscribe(authorizedUser: authorizedUser, subscriptionUser: subscriptionUser))
    }
    
    func subscribersButtonPressed() {
        print(subscribersFetchResultsController?.fetchedObjects?.count)
    }
    
    func subscriptionsButtonPressed() {
        print(subscriptionsFetchResultsController?.fetchedObjects?.count)
    }
    
}
