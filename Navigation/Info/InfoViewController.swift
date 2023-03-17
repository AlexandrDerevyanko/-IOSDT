//
//  InfoViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 12.11.2022.
//
import UIKit

class InfoViewController: UIViewController {
    
    private let networkService: NetworkServiceProtocol
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let peopleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button = CustomButton(title: "Button", bgColor: .cyan, action: buttonPressed)
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        startNetworkService()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(peopleLabel)
        view.addSubview(button)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            peopleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            peopleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            peopleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            button.topAnchor.constraint(equalTo: peopleLabel.bottomAnchor, constant: 16),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            button.widthAnchor.constraint(equalToConstant: 100),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func buttonPressed() {
        let alert = UIAlertController(title: "Hello world", message: "Message", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) {_ in
            print("Bye")
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) {_ in
            print("Bye")
        }
        alert.addAction(action)
        alert.addAction(action2)
        self.present(alert, animated: true, completion: nil)
    }
    
    private func startNetworkService() {
        networkService.titleRequest { [weak self] title in
            self?.titleLabel.text = title
        }
        networkService.orbitalPeriodRequest { [weak self] title in
            self?.descriptionLabel.text = title
        }

    }
    
}
