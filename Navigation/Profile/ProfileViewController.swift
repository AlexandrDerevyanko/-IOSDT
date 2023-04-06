
import UIKit
import StorageService
import iOSIntPackage

class ProfileViewController: UIViewController, ProfileDelegate {
        
    var user: User
    var currentUser: User? {
        return nil
    }
    lazy var profileHeaderView = ProfileHeaderView()
    var posts: [Post] {
        return CoreDataManeger.defaulManager.posts.filter{$0.user == user}
//        return user.postsSorted
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(FirstSectionTableViewCell.self, forCellReuseIdentifier: "FirstSectionCell")
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "SecondSectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        let signOutButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(pushSignOutButton))
        navigationItem.leftBarButtonItem = signOutButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Profile"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationController?.isNavigationBarHidden = false
        reloadData()
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            CoreDataManeger.defaulManager.reloadPosts()
            self.tableView.reloadData()
        }
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
    
    private func timer() {
        let timeInterval = 3600
        
        Timer.scheduledTimer(
            withTimeInterval: TimeInterval(timeInterval),
            repeats: false
        ) { timer in
            let alert = UIAlertController(title: "Attention", message: "You are in the application for more than one hour", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true)
        }
    }
    
    @objc
    private func pushSignOutButton() {
        CoreDataManeger.defaulManager.deauthorization(user: user)
        navigationController?.popViewController(animated: true)
    }
    
}


extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            let cell = profileHeaderView
            cell.user = user
            cell.delegate = self
            cell.setup()
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
            return posts.count
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
            let postInCell = posts[indexPath.row]
            cell.delegate = self
            cell.post = postInCell
            cell.setup()
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return tableView.frame.width / 3.2
        }
        if indexPath.section == 1 {
            return UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
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
            let postInCell = self.posts[indexPath.row]
            CoreDataManeger.defaulManager.deletePost(post: postInCell)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }

        return UISwipeActionsConfiguration(actions: [action])
    }
    
}

extension ProfileViewController {
    
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
        CoreDataManeger.defaulManager.favoritePost(post: post, isFavorite: true)
    }
    
}
