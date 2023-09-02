
import UIKit
import CoreData

class CommentsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var post: Post
    var user: User
    var coordinator: ProfileCoordinator?
    var commentsFetchResultsController: NSFetchedResultsController<Comment>?
    var coreDataManager = CoreDataManeger.defaulManager
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = 15
        tableView.clipsToBounds = true
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "UsersTableViewCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let commentTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.clipsToBounds = true
        textField.layer.cornerRadius = 15
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var commentButton = CustomButton(title: "Добавить комментарий", action: commentButtonPressed)
    
    init(post: Post, user: User) {
        self.post = post
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        initCommentsFetchResultsController()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(tableView)
        scrollView.addSubview(commentTextField)
        scrollView.addSubview(commentButton)
        setupConstraints()
        setupGestures()
    }
    
    func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(16)
            make.left.equalTo(scrollView.snp.left).offset(16)
            make.right.equalTo(scrollView.snp.right).offset(-16)
            make.centerX.equalTo(scrollView.snp.centerX)
//            make.centerY.equalTo(scrollView.snp.centerY)
            make.height.equalTo(self.view.frame.height - 320)
//            make.bottom.equalTo(commentTextField.snp.top).offset(-16)
        }
        commentTextField.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(6)
            make.left.equalTo(scrollView.snp.left).offset(16)
            make.right.equalTo(scrollView.snp.right).offset(-16)
//            make.bottom.equalTo(commentButton.snp.top).offset(-16)
            make.height.equalTo(50)
        }
        commentButton.snp.makeConstraints { make in
            make.top.equalTo(commentTextField.snp.bottom).offset(6)
            make.left.equalTo(scrollView.snp.left).offset(16)
            make.right.equalTo(scrollView.snp.right).offset(-16)
//            make.bottom.equalTo(scrollView.safeAreaLayoutGuide).offset(-16)
            make.height.equalTo(50)
        }
    }
    
    func initCommentsFetchResultsController() {
        let fetchRequest = Comment.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "dateCreated", ascending: false)]
        fetchRequest.predicate = NSPredicate(format: "post == %@", post)
        commentsFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        commentsFetchResultsController?.delegate = self
        try? commentsFetchResultsController?.performFetch()
    }
    
    func commentButtonPressed() {
        guard let text = commentTextField.text, text != "" else { return }
        coreDataManager.commentPost(postUUID: post.postID ?? UUID(), userLogin: coreDataManager.user?.login ?? "", text: text)
        commentTextField.text = ""
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboeardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboeardRectangle.height
                
            let loginButtonBottomPointY = self.commentButton.frame.origin.y + self.commentButton.frame.height
            let keyboardOriginY = self.view.frame.height - keyboardHeight
                
            let yOffset = keyboardOriginY < loginButtonBottomPointY ? loginButtonBottomPointY - keyboardOriginY + 16 : 0
                
            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }
    
    @objc
    private func didHideKeyboard (_ notification: Notification) {
        self.forcedHidingKeyboard()
    }
    
    @objc
    private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
}

extension CommentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsFetchResultsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "UsersTableViewCell", for: indexPath) as? CommentTableViewCell else {
            preconditionFailure("Error")
        }
        var commentInCell: Comment?
        commentInCell = commentsFetchResultsController?.fetchedObjects?[indexPath.row]
        cell.comment = commentInCell
        cell.setup()
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {

        switch type {
        case .insert:
//            ()
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
