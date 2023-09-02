
import UIKit
import CoreData

class LoginViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    lazy var coordinator = ProfileCoordinator(navigationController: self.navigationController)
    var logInDelegate: LoginDelegateProtocol?
    private let alertManager = AlertManager.defaulManager
    private let coreDataManager = CoreDataManeger.defaulManager
    private var users: [User] = []
    
    private let point: UIView = {
        let point = UIView()
        point.backgroundColor = .lightGray
        point.translatesAutoresizingMaskIntoConstraints = false
        return point
    }()
    
    private let logo: UIImageView = {
        let myView = UIImageView()
        myView.image = UIImage(named: "logo")
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
        logIn.backgroundColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray)
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
        password.backgroundColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray)
        password.font = UIFont.systemFont(ofSize: 16)
        password.placeholder = "Password"
        password.isSecureTextEntry = true
        password.autocapitalizationType = .none
        password.translatesAutoresizingMaskIntoConstraints = false
        return password
        }()
        
    private let logInButton: BlueButton = {
        let button = BlueButton()
        button.setTitle(NSLocalizedString("logIn-button-logInVC-localizable", comment: ""), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.createColor(lightMode: UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1), darkMode: .systemGray4)
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
        button.setTitle(NSLocalizedString("signUp-button-logInVC-localizable", comment: ""), for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.createColor(lightMode: UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1), darkMode: .systemGray4)
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
        users = coreDataManager.users
        setupUI()
        setupConstraints()
        checkUserStatus()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(didShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationItem.setHidesBackButton(true, animated: true)

    }
    
    private func checkUserStatus() {
        
        if let user = coreDataManager.user {
            if user.isLogIn {
                tabBarController?.tabBar.isHidden = false
                coordinator.pushProfileViewController(user: user, isUser: true)
            }
        }
    }
        
    private func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(logo)
        stackView.addArrangedSubview(loginTextFiled)
        stackView.addArrangedSubview(point)
        stackView.addArrangedSubview(passwordTextFiled)
        scrollView.addSubview(logInButton)
        scrollView.addSubview(signUpButton)
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
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        logo.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(100)
            make.centerX.equalTo(scrollView.snp.centerX)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(100)
            make.left.equalTo(scrollView.snp.left).offset(16)
            make.right.equalTo(scrollView.snp.right).offset(-16)
            make.centerX.equalTo(scrollView.snp.centerX)
        }
        loginTextFiled.snp.makeConstraints { make in
            make.height.equalTo(49)
        }
        passwordTextFiled.snp.makeConstraints { make in
            make.height.equalTo(49)
        }
        point.snp.makeConstraints { make in
            make.height.equalTo(0.45)
            make.left.equalTo(stackView.snp.left)
            make.right.equalTo(stackView.snp.right)
        }
        logInButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.left.equalTo(scrollView.snp.left).offset(16)
            make.right.equalTo(scrollView.snp.right).offset(-16)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(logInButton.snp.bottom).offset(16)
            make.height.equalTo(50)
            make.left.equalTo(scrollView.snp.left).offset(16)
            make.right.equalTo(scrollView.snp.right).offset(-16)
        }
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
        coordinator.pushSignupViewController()
    }

    @objc
    private func forcedHidingKeyboard() {
        self.view.endEditing(true)
        self.scrollView.setContentOffset(.zero, animated: true)
    }
    
}

extension LoginViewController {
    
    private func logIn() {
        let email = loginTextFiled.text
        let password = passwordTextFiled.text
        
        logInDelegate?.logIn(logIn: email, password: password, completion: { [self] autorizationData, autorizattionError, user in
            if let autorizattionError {
                alertManager.autorizationErrors(showIn: self, error: autorizattionError)
                return
            }
            guard let user else {
                alertManager.autorizationErrors(showIn: self, error: .invalidPassword)
                return
            }
            coreDataManager.authorization(user: user)
            coreDataManager.user = user
            tabBarController?.tabBar.isHidden = false
            coordinator.pushProfileViewController(user: user, isUser: true)
        })
    }
}
