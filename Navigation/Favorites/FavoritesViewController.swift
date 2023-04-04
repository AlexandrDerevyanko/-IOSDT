//
//  FavoritesViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 01.04.2023.
//


import UIKit

class FavoritesViewController: UIViewController {
        
    var user: User?
    var filteredPosts: [Post] {
        guard let user else { return [] }
        return user.postsSorted
    }
    var posts: [Post] {
        var posts: [Post] = []
        for i in filteredPosts {
            if i.isFavorite {
                posts.append(i)
            }
                
        }
        return posts
    }
    
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
    
    func checkUserStatus() {
        let auth = CoreDataManeger.defaulManager.users
        if auth.isEmpty {
            navigationController?.popToRootViewController(animated: true)
            Alert.defaulAlert.errors(showIn: self, error: .autorization)
        } else {
            guard let user = auth.last else { return }
            if user.isLogIn {
                DispatchQueue.main.async {
                    self.user = user
                    self.tableView.reloadData()
                }
            } else {
                self.user = nil
                tableView.reloadData()
                Alert.defaulAlert.errors(showIn: self, error: .autorization)
            }
        }
    }
    
}


extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "FirstSectionCell", for: indexPath) as? FavoritePostTableViewCell else {
                preconditionFailure("Error")
            }
            let postInCell = posts[indexPath.row]
            
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
            let postInCell = posts[indexPath.row]
            CoreDataManeger.defaulManager.favoritePost(post: postInCell, isFavorite: false)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}
