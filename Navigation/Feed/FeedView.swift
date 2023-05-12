//
//  FeedView.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 17.02.2023.
//

import UIKit

protocol FeedViewDelegate: AnyObject {
    func infoButtonPressed()
    func postButtonPressed()
    func checkGuessButtonPressed(text: String)
}

class FeedView: UIView {
    
    private weak var delegate: FeedViewDelegate?
    
    init(delegate: FeedViewDelegate) {
        self.delegate = delegate
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    private var dataSource = Feed(title: "Some Title", description: "Some description")

    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.layer.cornerRadius = 12
        textField.clipsToBounds = true
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var checkButton = CustomButton(title: "Check", bgColor: .cyan, action: checkGuessButtonPressed)
    private lazy var infoButton = CustomButton(title: "Info", bgColor: .cyan, action: infoButtonPressed)
    private lazy var postButton = CustomButton(title: "Post", bgColor: .cyan, action: postButtonPressed)
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "Enter password"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(descriptionLabel)
        addSubview(stackView)
        addSubview(textField)
        addSubview(label)
        stackView.addArrangedSubview(checkButton)
        stackView.addArrangedSubview(infoButton)
        stackView.addArrangedSubview(postButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            textField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.heightAnchor.constraint(equalToConstant: 40),
            
            stackView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 16),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            checkButton.widthAnchor.constraint(equalToConstant: 100),
            checkButton.heightAnchor.constraint(equalToConstant: 40),
            
            infoButton.widthAnchor.constraint(equalToConstant: 100),
            infoButton.heightAnchor.constraint(equalToConstant: 40),
            
            postButton.widthAnchor.constraint(equalToConstant: 100),
            postButton.heightAnchor.constraint(equalToConstant: 40),
            
            label.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            label.heightAnchor.constraint(equalToConstant: 50)
        ])
        
//        descriptionLabel.snp.makeConstraints { make in
//            make.top.equalTo(safeAreaLayoutGuide).offset(16)
//            make.centerX.equalTo(snp.centerX)
//        }
//        textField.snp.makeConstraints { make in
//            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
//            make.left.equalTo(snp.left).offset(16)
//            make.right.equalTo(snp.right).offset(16)
//            make.height.equalTo(40)
//        }
        
    }
    
    func check(status: Bool) {
        if status {
            descriptionLabel.text = "Ok"
            descriptionLabel.textColor = .green
        } else {
            descriptionLabel.text = "Error"
            descriptionLabel.textColor = .red
        }
    }
    
    func infoButtonPressed() {
        delegate?.infoButtonPressed()
    }
    
    func postButtonPressed() {
        delegate?.postButtonPressed()
    }
    
    func checkGuessButtonPressed() {
        delegate?.checkGuessButtonPressed(text: textField.text ?? "")
    }
    
}
