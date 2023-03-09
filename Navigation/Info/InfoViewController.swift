//
//  InfoViewController.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 12.11.2022.
//
import UIKit

class InfoViewController: UIViewController {
    
    private var source = SecondPost(title: "Some title")
    
    private let alertController = UIAlertController(title: "Hello world", message: "Message", preferredStyle: .alert)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "First Text"
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var button = CustomButton(title: "Button", bgColor: .cyan, action: buttonPressed)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(button)
        titleLabel.text = source.title
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
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
    
}
