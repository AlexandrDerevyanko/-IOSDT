
import UIKit
import CoreData

class UsersViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var post: Post?
    var subscribers: [Subscriber]?
    var subscriptions: [Subscription]?
    
    var likesFetchResultsController: NSFetchedResultsController<Like>?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        tableView.register(UserTableViewCell.self, forCellReuseIdentifier: "UsersTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if post != nil {
            initLikesFetchResultsController()
        }
        setupUI()
    }
    
    func setupUI() {
        view.addSubview(tableView)
        setupConstraints()
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    func initLikesFetchResultsController() {
        let fetchRequest = Like.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "post == %@", post ?? Post())
        likesFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        likesFetchResultsController?.delegate = self
        try? likesFetchResultsController?.performFetch()
    }
    
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if post != nil {
            return likesFetchResultsController?.fetchedObjects?.count ?? 0
        } else if let subscribers {
            return subscribers.count
        } else if let subscriptions {
            return subscriptions.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as? UserTableViewCell else {
            preconditionFailure("Error")
        }
        var userInCell: User?
        if post != nil {
            userInCell =  likesFetchResultsController?.fetchedObjects?[indexPath.row].user
        } else if let subscribers {
            userInCell = subscribers[indexPath.row].userSubscriber
        } else if let subscriptions {
            userInCell = subscriptions[indexPath.row].userSubscription
        }
        cell.user = userInCell
        cell.setup()
        return cell
    }
    
    
}
