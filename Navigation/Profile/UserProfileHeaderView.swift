//
//  ProfileTableHederView.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 12.12.2022.
//

import UIKit

class UserProfileView: UIView {
    
    init(delegate: ProfileDelegate, user: User, subscribers: Int, subscriptions: Int) {
        self.delegate = delegate
        self.user = user
        super.init(frame: .zero)
        setup(subscribers: subscribers, subscriptions: subscriptions)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private weak var delegate: ProfileDelegate?
    private var user: User
    private var authorizedUser: User {
        return CoreDataManeger.defaulManager.user ?? User()
    }
    private var isSubscribe: Bool {
        return false
    }
    private var statusText: String = ""

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
        myView.image = UIImage(systemName: "camera")
        myView.translatesAutoresizingMaskIntoConstraints = false
        return myView
    }()

    let fullNameLabel: UILabel = {
        let label = UILabel()
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
    
    private let subscriptionsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subscribersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    private lazy var layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
//        return layout
//    }()
//
//    private lazy var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: "CustomCell")
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
//        collectionView.delegate = self
//        collectionView.dataSource = self
//        collectionView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        return collectionView
//    }()
//

    private lazy var subscribeButton = CustomButton(title: "Subscribe", titleColor: .white, bgColor: UIColor.createColor(lightMode: UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1), darkMode: .systemGray4), hidden: isSubscribe, action: subscribeButtonPressed)

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            endEditing(true)
        }
        super.touchesBegan(touches, with: event)
    }

    private func setupUI() {
        backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        addSubview(subscribeButton)
        addSubview(statusTextField)
        addSubview(statusLabel)
        addSubview(fullNameLabel)
        addSubview(avatarImageView)
        addSubview(subscribersLabel)
        addSubview(subscriptionsLabel)
        setupConstraints()
    }

    func setup(subscribers: Int, subscriptions: Int) {
        statusLabel.text = user.status
        if statusLabel.text == nil {
            statusLabel.text = NSLocalizedString("status-label-profileVC-localizable", comment: "")
        }
        fullNameLabel.text = user.fullName
        avatarImageView.image = UIImage(data: user.avatar ?? Data())
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.addGestureRecognizer(tapGestureRecognizer)
        subscribersLabel.text = "Подписчики: \(subscribers)"
        subscriptionsLabel.text = "Подписки: \(subscriptions)"
    }

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        ImagePicker.defaultPicker.getImage(in: (self.window?.rootViewController)!) { imageData in
            DispatchQueue.main.async {
                if let imageData {
                    CoreDataManeger.defaulManager.updateUserAvatar(user: self.user, imageData: imageData)
                    self.avatarImageView.image = UIImage(data: imageData)
                }
            }
        }
    }
    
    private func setupConstraints() {
        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.left.equalTo(16)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        fullNameLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
            make.centerX.equalTo(snp.centerX)
        }

        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(fullNameLabel.snp.bottom).offset(30)
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.right.equalTo(-16)
        }
        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(16)
            make.left.equalTo(avatarImageView.snp.right).offset(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }
        subscribeButton.snp.makeConstraints { make in
            make.top.equalTo(statusTextField.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.right.equalTo(-16)
            make.height.equalTo(40)
        }

        subscribersLabel.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(16)
            make.left.equalTo(16)
            make.bottom.equalTo(-16)
        }
        subscriptionsLabel.snp.makeConstraints { make in
            make.top.equalTo(subscribeButton.snp.bottom).offset(16)
            make.left.equalTo(subscribersLabel.snp.right).offset(16)
            make.bottom.equalTo(-16)
        }
    }
    
    @objc
    private func subscribeButtonPressed() {
        delegate?.subscribe(authorizedUser: authorizedUser, subscriptionUser: user)
    }

}

//extension UserProfileView: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        <#code#>
//    }
//
//
//}
