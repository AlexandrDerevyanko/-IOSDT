
import UIKit
import CoreData

class FeedViewController: UIViewController, NSFetchedResultsControllerDelegate {
        
    private var coreDataManager = CoreDataManeger.defaulManager
//    var isSearch: Bool = false
//    var searchText: String = ""
    var fetchResultsController: NSFetchedResultsController<Post>?
    var likesFetchResultsController: NSFetchedResultsController<Like>?
    lazy var coordinator = ProfileCoordinator(navigationController: self.navigationController)
//    var coordinator: ProfileCoordinatorProtocol?
    
    func initFetchResultsController() {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController?.delegate = self
        try? fetchResultsController?.performFetch()
    }
    
    func initLikesFetchResultsController(post: Post) {
        let fetchRequest = Like.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "post == %@", post)
        likesFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        likesFetchResultsController?.delegate = self
        try? likesFetchResultsController?.performFetch()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        tableView.register(FeedFirstSectionTableViewCell.self, forCellReuseIdentifier: "FeedFirstSectionCell")
        tableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: "FeedPostCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initFetchResultsController()
        setupUI()
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
    
}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            if let count = fetchResultsController?.fetchedObjects?.count, count <= 100 {
                return count
            } else {
                return 100
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 130 : UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedFirstSectionCell", for: indexPath) as? FeedFirstSectionTableViewCell else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
                return cell
            }
            let users = coreDataManager.users
            cell.users = users
            return cell
        } else if indexPath.section == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostCell", for: indexPath) as? FeedPostTableViewCell else {
                preconditionFailure("Error")
            }
            let postInCell = fetchResultsController?.fetchedObjects?[indexPath.row]
            cell.delegate = self
            cell.post = postInCell
            cell.setup()
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
////        if editingStyle == .delete {
////            let postInCell = self.fetchResultsController?.fetchedObjects![indexPath.row]
////            CoreDataManeger.defaulManager.likePost(post: postInCell ?? Post(), isFavorite: false)
////            initFetchResultsController()
////            tableView.reloadData()
////        }
//    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            ()
//            tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .automatic)
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


extension FeedViewController: FeedDelegate {
    
    func authorLabelPressed(user: User) {
        let currentUser = coreDataManager.user
        var isUser: Bool
        if currentUser == user {
            isUser = true
        } else {
            isUser = false
        }
        coordinator.pushProfileViewController(user: user, isUser: isUser)
    }
    
    func likePost(post: Post) {
        
        initLikesFetchResultsController(post: post)
        let likesArray: [Like] = likesFetchResultsController?.fetchedObjects ?? []
        let authorizedUser = coreDataManager.user
        for i in likesArray {
            if i.login == authorizedUser?.login {
                return
            }
        }
        coreDataManager.likePost(postUUID: post.postID ?? UUID(), userLogin: authorizedUser?.login ?? "")
                
                
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
        
        coordinator.pushUsersViewController(viewController: usersVC)
    }
    
    func pushCommentsViewController(post: Post) {
        coordinator.pushCommentsViewController(user: coreDataManager.user ?? User(), post: post)
    }
    
}
