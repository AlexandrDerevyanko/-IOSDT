
import UIKit

class SubscribersViewController: UIViewController {
    
    var subscriptions: [Subscription]?
    var subscribers: [Subscriber]?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .systemBackground
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        tableView.register(SubscribersTableViewCell.self, forCellReuseIdentifier: "FirstSectionCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        setupConstraints()
    }
    
    private func setupConstraints() {
        
    }
    
}

extension SubscribersViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let subscriptions {
            return subscriptions.count
        } else if let subscribers {
            return subscribers.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? SubscribersTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        if let subscriptions {
            cell.name = subscriptions[indexPath.row].user?.fullName
        } else if let subscribers {
            cell.name = subscribers[indexPath.row].user?.fullName
        }
        return cell
    }
    
    
}
