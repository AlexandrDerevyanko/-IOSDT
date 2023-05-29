//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 01.04.2023.
//


import UIKit
import CoreData

class FavoritesViewController: UIViewController, NSFetchedResultsControllerDelegate {
        
    var isSearch: Bool = false
    var searchText: String = ""
    var user: User? {
        return CoreDataManeger.defaulManager.user
    }
//    var filteredPosts: [Post] {
//        guard let user else { return [] }
//        return user.postsSorted
//    }
//    var posts: [Post] {
//        if isSearch {
//            return getSearchPosts()
//        } else {
//            return getPosts()
//        }
//    }
    
    var fetchResultsController: NSFetchedResultsController<Post>!
    
    func initFetchResultsController() {
        let fetchRequest = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "user == %@", user ?? User())
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
    }
    
    lazy var searchButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(pushSearchButton))
    lazy var clearButton = UIBarButtonItem(title: "Clear", style: .plain, target: self, action: #selector(pushClearButton))
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FavoritePostTableViewCell.self, forCellReuseIdentifier: "FirstSectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkUserStatus()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Favorites posts"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.isNavigationBarHidden = false
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
        checkUserStatus()
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
                   
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
        ])
    }
    
//    private func getPosts() -> [Post] {
//        var posts: [Post] = []
//        for i in filteredPosts {
//            if i.isFavorite {
//                posts.append(i)
//            }
//        }
//        return posts
//    }
//
//    private func getSearchPosts() -> [Post] {
//        var posts: [Post] = []
//        for i in filteredPosts {
//            if i.user?.login == searchText {
//                posts.append(i)
//            }
//        }
//        return posts
//    }
    
    private func setupButtons() {
        clearButton.isHidden = true
        navigationItem.rightBarButtonItems = [searchButton, clearButton]
    }
    
    private func checkUserStatus() {
        
        DispatchQueue.main.async {
            if self.user == nil {
                self.tableView.reloadData()
                Alert.defaulAlert.errors(showIn: self, error: .autorization)
            } else {
                self.initFetchResultsController()
                self.tableView.reloadData()
            }
        }
    }
    
    @objc
    private func pushSearchButton() {
        SearchPicker.defaultPicker.getText(showPickerIn: self, title: "Поиск", message: "Введите email пользователя для поиска") { text in
            self.searchText = text
            self.isSearch = true
            self.tableView.reloadData()
            self.clearButton.isHidden = false
        }
    }
    
    @objc
    private func pushClearButton() {
        self.isSearch = false
        self.clearButton.isHidden = true
        tableView.reloadData()
    }
    
}


extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResultsController?.fetchedObjects?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstSectionCell", for: indexPath) as? FavoritePostTableViewCell else {
                preconditionFailure("Error")
            }
            let postInCell = fetchResultsController.fetchedObjects![indexPath.row]
            
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
            let postInCell = self.fetchResultsController.fetchedObjects![indexPath.row]
            CoreDataManeger.defaulManager.favoritePost(post: postInCell, isFavorite: false)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .automatic)
        }
    }
    
}
