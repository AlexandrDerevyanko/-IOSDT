
import UIKit
import CoreData

protocol FeedDelegate {
    func authorPressed(viewController: UIViewController)
}

class FeedViewController: UIViewController, NSFetchedResultsControllerDelegate {
        
    private let viewModel: FeedViewModelProtocol

    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isSearch: Bool = false
    var searchText: String = ""

    var fetchResultsController: NSFetchedResultsController<Post>?
    
    func initFetchResultsController() {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController?.delegate = self
        try? fetchResultsController?.performFetch()
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        tableView.register(FeedPostTableViewCell.self, forCellReuseIdentifier: "FeedPostCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkUserStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Feed"
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        checkUserStatus()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
                   
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
    private func checkUserStatus() {
        
        DispatchQueue.main.async {
                self.initFetchResultsController()
                self.tableView.reloadData()
        }
    }
    
}


extension FeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedPostCell", for: indexPath) as? FeedPostTableViewCell else {
                preconditionFailure("Error")
            }
        let postInCell = fetchResultsController?.fetchedObjects![indexPath.row]
        cell.delegate = self
        cell.post = postInCell
        cell.setup()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let postInCell = self.fetchResultsController?.fetchedObjects![indexPath.row]
            CoreDataManeger.defaulManager.favoritePost(post: postInCell ?? Post(), isFavorite: false)
            initFetchResultsController()
            tableView.reloadData()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .automatic)
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
    
    func authorPressed(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}


// class FeedViewController: UIViewController {
//
//    private let viewModel: FeedViewModelProtocol
//
//    private lazy var feedView = FeedView(delegate: self)
//
//
//    init(viewModel: FeedViewModelProtocol) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func loadView() {
//        super.loadView()
//        view = feedView
//        bindViewModel()
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        title = "Feed"
//        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = .systemGray6
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
//        navigationController?.navigationBar.tintColor = .black
//        navigationController?.navigationBar.standardAppearance = appearance
//        navigationController?.navigationBar.compactAppearance = appearance
//        navigationController?.navigationBar.scrollEdgeAppearance = appearance
//    }
//
//    func bindViewModel() {
//        viewModel.onStateDidChange = { [weak self] state in
//            guard let self = self else {
//                return
//            }
//            switch state {
//            case .initial:
//                ()
//            case .checkTrue:
//                self.feedView.check(status: true)
//            case .checkFalse:
//                self.feedView.check(status: false)
//            case .error:
//                ()
//            }
//        }
//    }
//
//}
