//
//  SignupViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 17.03.2023.
//

import UIKit
import FirebaseAuth
import SnapKit

class SignupViewController: UIViewController {
    
    var signUpDelegate: LoginDelegateProtocol?
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 10
        stackView.layer.borderWidth = 0.5
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        return stackView
    }()
    
    private let loginTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Email"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let confirmPasswordTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Confirm password"
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let createAccountButton: BlueButton = {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(stackView)
        stackView.addArrangedSubview(loginTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        view.addSubview(createAccountButton)
        setupButton()
        setupConstraints()
        addTargets()
    }
    
    private func setupConstraints() {
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
        }
        
        loginTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        confirmPasswordTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        createAccountButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
    }
    
    private func setupButton() {
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(pushCancelButton))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func addTargets() {
        createAccountButton.addTarget(self, action: #selector(pushCreateAccountButton), for: .touchUpInside)
    }
    
    @objc
    private func pushCancelButton() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc
    private func pushCreateAccountButton() {
        singUp()
    }
    
    private func singUp() {
        let email = loginTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text
        
        signUpDelegate?.signUp(email: email, password: password, passwordConfirmation: confirmPassword, completion: { data, error in
            if error != nil {
                switch error {
                case .emptyPasswordOrEmail:
                    let alert = UIAlertController(title: "Ошибка", message: AutorizationError.emptyPasswordOrEmail.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .invalidPassword:
                    let alert = UIAlertController(title: "Ошибка", message: AutorizationError.invalidPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .weakPassword:
                    let alert = UIAlertController(title: "Ошибка", message: AutorizationError.weakPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .mismatchPassword:
                    let alert = UIAlertController(title: "Ошибка", message: AutorizationError.mismatchPassword.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .notFound:
                    let alert = UIAlertController(title: "Ошибка", message: AutorizationError.notFound.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .emailAlreadyInUse:
                    let alert = UIAlertController(title: "Ошибка", message: AutorizationError.emailAlreadyInUse.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .invalidEmail:
                    let alert = UIAlertController(title: "Ошибка", message: AutorizationError.invalidEmail.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                case .unexpected:
                    let alert = UIAlertController(title: "Ошибка", message: AutorizationError.unexpected.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default))
                    self.present(alert, animated: true)
                default:
                    return
                }
            } else {
                switch data {
                case .logIn:
                    return
                case .signUp:
                    self.navigationController?.popToRootViewController(animated: true)
                default:
                    return
                }
            }
        })
    }
}
