
import UIKit
import CoreData

class LoginViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    var fetchResultsController: NSFetchedResultsController<User>?
    var logInDelegate: LoginDelegateProtocol?
    
    func initFetchResultsController() {
        let fetchRequest = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastAutorizationDate", ascending: false)]
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManeger.defaulManager.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController?.delegate = self
        try? fetchResultsController?.performFetch()
    }
    
    private let point: UIView = {
        let point = UIView()
        point.backgroundColor = .lightGray
        point.translatesAutoresizingMaskIntoConstraints = false
        return point
    }()
    
    private let logo: UIImageView = {
        let myView = UIImageView()
        myView.image = UIImage(named: "logo")!
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
        
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
        
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
        
    private let loginTextFiled: TextFieldWithPadding = {
        let logIn = TextFieldWithPadding()
        logIn.tag = 0
        logIn.text = "corgi@gmail.com"
        logIn.textColor = .black
        logIn.backgroundColor = .systemGray6
        logIn.font = UIFont.systemFont(ofSize: 16)
        logIn.placeholder = "Email or phone"
        logIn.autocapitalizationType = .none
        logIn.translatesAutoresizingMaskIntoConstraints = false
        return logIn
        }()
        
    private let passwordTextFiled: TextFieldWithPadding = {
        let password = TextFieldWithPadding()
        password.tag = 1
        password.text = "123456"
        password.textColor = .black
        password.backgroundColor = .systemGray6
        password.font = UIFont.systemFont(ofSize: 16)
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
        }()
        
    private let logInButton: BlueButton = {
        let button = BlueButton()
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signUpButton: BlueButton = {
        let button = BlueButton()
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowRadius = 4
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.7
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupConstraints()
        initFetchResultsController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        DispatchQueue.main.async {
            self.initFetchResultsController()
            self.checkUserStatus()
        }

    }
    
    func checkUserStatus() {
        DispatchQueue.main.async {
            if self.fetchResultsController!.fetchedObjects!.isEmpty {
                return
            } else {
                let user = self.fetchResultsController!.fetchedObjects![0]
                if user.isLogIn {
                    DispatchQueue.main.async {
                        CoreDataManeger.defaulManager.user = user
                        let profileVC = ProfileViewController(user: user)
                        self.navigationController?.pushViewController(profileVC, animated: true)
                    }
                }
            }
        }
    }
        
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(logo)
        scrollView.addSubview(logInButton)
        scrollView.addSubview(signUpButton)
        stackView.addArrangedSubview(loginTextFiled)
        stackView.addArrangedSubview(point)
        stackView.addArrangedSubview(passwordTextFiled)
        setupButton()
        setupGestures()
    }
        
    private func setupButton() {
        logInButton.addTarget(self, action: #selector(logInButtonPressed), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonPressed), for: .touchUpInside)
        }
        
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.forcedHidingKeyboard))
        self.view.addGestureRecognizer(tapGesture)
    }
        
    private func setupConstraints() {
        NSLayoutConstraint.activate( [
        
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logo.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
            logo.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            logo.heightAnchor.constraint(equalToConstant: 100),
            logo.widthAnchor.constraint(equalToConstant: 100),
            
            stackView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 120),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            
            loginTextFiled.heightAnchor.constraint(equalToConstant: 49),
            
            passwordTextFiled.heightAnchor.constraint(equalToConstant: 49),
            
            point.heightAnchor.constraint(equalToConstant: 0.45),
            point.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            point.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            
            logInButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            logInButton.heightAnchor.constraint(equalToConstant: 50),
            logInButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            logInButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16),
            
            signUpButton.topAnchor.constraint(equalTo: logInButton.bottomAnchor, constant: 16),
            signUpButton.heightAnchor.constraint(equalToConstant: 50),
            signUpButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 16),
            signUpButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: -16)
        
        ])
    }
        
    @objc
    private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboeardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboeardRectangle.height
                
            let loginButtonBottomPointY = self.logInButton.frame.origin.y + self.logInButton.frame.height
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
    private func logInButtonPressed() {
        logIn()
    }
    
    @objc
    private func signUpButtonPressed() {
        let VC = SignupViewController()
        VC.signUpDelegate = MyLoginFactory().makeCheckerService()
        navigationController?.pushViewController(VC, animated: true)
    }
        
    @objc
    private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
}

extension LoginViewController {
    
    func logIn() {
        let email = loginTextFiled.text
        let password = passwordTextFiled.text
        logInDelegate?.logIn(logIn: email, password: password, completion: { data, error, user  in
            if let error = error {
                Alert.defaulAlert.errors(showIn: self, error: error)
            }
            guard let user = user else {
                Alert.defaulAlert.errors(showIn: self, error: .invalidPassword)
                return
            }
            CoreDataManeger.defaulManager.authorization(user: user)
            CoreDataManeger.defaulManager.user = user
            let profileVC = ProfileViewController(user: user)
            self.navigationController?.pushViewController(profileVC, animated: true)
        })
    }
}
