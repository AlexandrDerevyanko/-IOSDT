
import UIKit
import CoreData

let settingsArray: [String] = ["Имя"]

protocol SettingsViewDelegate {
    func saveName(name: String?)
    func savePassword(password: String?)
    func saveConfirmedPassword(confirmedPassword: String?)
}

class SettingsViewController: UIViewController {
    
    var user: User
    var coordinator: ProfileCoordinatorProtocol?
    var isChangePassword: Bool
    private var coreDataManager = CoreDataManeger.defaulManager
    private var alertmanager = AlertManager.defaulManager
    private var userName: String?
    private var userPassword: String?
    private var userConfirmedPassword: String?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.layer.cornerRadius = 20
        tableView.backgroundColor = .systemGray5.withAlphaComponent(0.6)
        tableView.register(SettingsTableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var changePasswordButton = CustomButton(title: "Сменить пароль", action: changePasswordButtonPressed)
    
    private lazy var saveButton = CustomButton(title: "Сохранить", bgColor: UIColor(red: 72/255, green: 133/255, blue: 204/255, alpha: 1), action: saveButtonPressed)
    
    init(user: User, isChangePassword: Bool) {
        self.user = user
        self.isChangePassword = isChangePassword
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isChangePassword ? changePasswordButton.isHidden = true : nil
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "Settings"
        let appearance = UINavigationBarAppearance()
//        appearance.backgroundColor = standardBackgroundColor
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black.withAlphaComponent(0.8)
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(saveButton)
        view.addSubview(changePasswordButton)
        setupConstraints()
    }
    
    private func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(saveButton.snp.top).offset(-16)
        }
        saveButton.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(16)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(changePasswordButton.snp.top).offset(-16)
        }
        changePasswordButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(16)
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-100)
        }
    }
    
    @objc
    private func saveButtonPressed() {
        if isChangePassword {
            if let userPassword, let userConfirmedPassword {
                if userPassword == "" || userConfirmedPassword == "" {
                    alertmanager.autorizationErrors(showIn: self, error: .empty)
                    return
                }
                if userPassword.count < 6 || userConfirmedPassword.count < 6 {
                    alertmanager.autorizationErrors(showIn: self, error: .weakPassword)
                    return
                }
                if userPassword == user.password {
                    coreDataManager.changePassword(user: user, password: userConfirmedPassword)
                    coordinator?.pushProfileViewController(user: user, isUser: true)
                    return
                } else {
                    alertmanager.alert(title: "Ошибка", message: "Неверно введен старый пароль", okActionTitle: "Ок", showIn: self)
                }
                
            } else {
                alertmanager.autorizationErrors(showIn: self, error: .empty)
            }
        } else {
            if let userName {
                if userName == "" {
                    alertmanager.alert(title: "Ошибка", message: "Пустое поле", okActionTitle: "Ок", showIn: self)
                    return
                }
                coreDataManager.changeUserName(user: user, name: userName)
                coordinator?.pushProfileViewController(user: user, isUser: true)
                return
            }
        }
    }

    @objc
    private func changePasswordButtonPressed() {
        coordinator?.pushSettingsViewController(user: user, isChangePassword: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Настройки"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isChangePassword ? 2 : settingsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath) as? SettingsTableViewCell else {
            preconditionFailure("Error")
        }
        if isChangePassword {
            if indexPath.row == 0 {
                cell.textDescription = "Введите старый пароль"
            } else if indexPath.row == 1 {
                cell.textDescription = "Введте новый пароль"
            }
            cell.isChangePassword = true
        } else {
            cell.textDescription = settingsArray[indexPath.row]
            if indexPath.row == 0 {
                cell.text = user.fullName
            }
        }
        cell.delegate = self
        cell.textField.tag = indexPath.row
        cell.setup()
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 1 {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
}

extension SettingsViewController: SettingsViewDelegate {
    func saveName(name: String?) {
        if let name {
            userName = name
        }
    }
    
    func savePassword(password: String?) {
        if let password {
            userPassword = password
        }
    }
    
    func saveConfirmedPassword(confirmedPassword: String?) {
        if let confirmedPassword {
            userConfirmedPassword = confirmedPassword
        }
    }
}
