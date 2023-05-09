//
//  ProfileTableHederView.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 12.12.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    
    var delegate: ProfileDelegate?
    var user: User!
    var statusText: String = ""

    let statusTextField: UITextField = {
        let fText = UITextField()
        fText.borderStyle = .roundedRect
        fText.contentVerticalAlignment = .center
        fText.font = UIFont.systemFont(ofSize: 15)
        fText.backgroundColor = UIColor.createColor(lightMode: .systemGray6, darkMode: .systemGray)
        fText.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        fText.layer.cornerRadius = 12
        fText.clipsToBounds = true
        fText.translatesAutoresizingMaskIntoConstraints = false
        return fText
    }()

    let avatarImageView: UIImageView = {
        let myView = UIImageView()
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
        label.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
            
    private let statusLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var setStatusButton = CustomButton(title: NSLocalizedString("setStatus-button-profileVC-localizable", comment: ""), titleColor: .white, bgColor: UIColor.createColor(lightMode: UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1), darkMode: .systemGray4), action: setStatusButtonPressed)
    private lazy var newPostButton = CustomButton(title: NSLocalizedString("newPost-button-profileVC-localizable", comment: ""), titleColor: .white, bgColor: UIColor.createColor(lightMode: UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1), darkMode: .systemGray4), action: newPostButtonPressed)

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        addSubview(setStatusButton)
        addSubview(statusTextField)
        addSubview(statusLabel)
        addSubview(fullNameLabel)
        addSubview(avatarImageView)
        addSubview(newPostButton)
        setupConstraints()
    }
    
    func setup() {
        statusLabel.text = user.status
        if statusLabel.text == nil {
            statusLabel.text = NSLocalizedString("status-label-profileVC-localizable", comment: "")
        }
        fullNameLabel.text = user.fullName
        avatarImageView.image = UIImage(data: user.avatar ?? Data())
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        ImagePicker.defaultPicker.getImage(in: (self.window?.rootViewController)!) { imageData in
            DispatchQueue.main.async {
                if let imageData {
                    self.avatarImageView.image = UIImage(data: imageData)
                    CoreDataManeger.defaulManager.updateUserAvatar(user: self.user, imageData: imageData)
                }
            }
        }
    }
    
        
    @objc
    private func setStatusButtonPressed() {
        CoreDataManeger.defaulManager.updateUserStatus(user: user, newStatus: statusTextField.text)
        statusLabel.text = statusTextField.text ?? ""
    }

    @objc
    private func newPostButtonPressed() {
        delegate?.pushNewPostViewController()
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
            setStatusButton.bottomAnchor.constraint(equalTo: newPostButton.topAnchor, constant: -16),
            
            statusLabel.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -70),
            statusLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            statusTextField.bottomAnchor.constraint(equalTo: setStatusButton.topAnchor, constant: -15),
            statusTextField.leftAnchor.constraint(equalTo: leftAnchor, constant: 132),
            statusTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            statusTextField.heightAnchor.constraint(equalToConstant: 40),

            newPostButton.topAnchor.constraint(equalTo: setStatusButton.bottomAnchor, constant: 16),
            newPostButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            newPostButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            newPostButton.heightAnchor.constraint(equalToConstant: 50),
            newPostButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
}
