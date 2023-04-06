//
//  SignupViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 17.03.2023.
//

import UIKit
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
    
    private let fullNameTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Full name"
        textField.text = "Corgi Kevin"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let loginTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Email"
        textField.text = "corgi@gmail.com"
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let passwordTextField: TextFieldWithPadding = {
        let textField = TextFieldWithPadding()
        textField.textColor = .black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Password"
        textField.text = "123456"
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
        textField.text = "123456"
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
        stackView.addArrangedSubview(fullNameTextField)
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
        
        fullNameTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
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
        signUp()
    }
    
    private func signUp() {
        
        let fullName = fullNameTextField.text
        let email = loginTextField.text
        let password = passwordTextField.text
        let confirmPassword = confirmPasswordTextField.text

        signUpDelegate?.signUp(fullName: fullName, email: email, password: password, passwordConfirmation: confirmPassword, completion: { data, error in
            if let error = error {
                Alert.defaulAlert.errors(showIn: self, error: error)
            } else {
                switch data {
                case .logIn:
                    return
                case .signUp:
                    self.navigationController?.popViewController(animated: true)
                default:
                    return
                }
            }
        })
    }
}
