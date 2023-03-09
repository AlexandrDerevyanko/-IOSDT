//
//  ProfileTableHederView.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 12.12.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    
    var statusText: String = ""

    let statusTextField: UITextField = {
        let fText = UITextField()
        fText.borderStyle = .roundedRect
        fText.contentVerticalAlignment = .center
        fText.textColor = .black
        fText.font = UIFont.systemFont(ofSize: 15)
        fText.layer.cornerRadius = 12
        fText.clipsToBounds = true
        fText.layer.borderColor = UIColor.black.cgColor
        fText.layer.borderWidth = 1
        fText.translatesAutoresizingMaskIntoConstraints = false
        return fText
    }()

    let avatarImageView: UIImageView = {
        let myView = UIImageView()
        myView.image = UIImage(named: "corgi")!
        myView.layer.cornerRadius = 50
        myView.clipsToBounds = true
        myView.layer.borderColor = UIColor.white.cgColor
        myView.layer.borderWidth = 3
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()
            
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Corgi"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
            
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting for something"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setStatusButton = CustomButton(title: "Set status", titleColor: .white, bgColor: .blue, action: setStatusButtonPressed)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setupUI()
        #if DEBUG
//        backgroundColor = .cyan
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }
    
    private func setupUI() {
        addSubview(setStatusButton)
        addSubview(statusTextField)
        addSubview(statusLabel)
        addSubview(fullNameLabel)
        addSubview(avatarImageView)
        setupConstraints()
    }
    
    func setup(with user: User) {
        statusLabel.text = user.status
        fullNameLabel.text = user.fullName
        avatarImageView.image = user.avatar
    }
        
    @objc private func setStatusButtonPressed() {
        statusLabel.text = statusTextField.text ?? ""
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            avatarImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            
            fullNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 27),
            fullNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            setStatusButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 40),
            setStatusButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            setStatusButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            setStatusButton.heightAnchor.constraint(equalToConstant: 50),
            setStatusButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            
            statusLabel.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -70),
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            statusTextField.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -15),
            statusTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 132),
            statusTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            statusTextField.heightAnchor.constraint(equalToConstant: 40)

        ])
    }
    
}
