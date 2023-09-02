
import UIKit

class UserTableViewCell: UITableViewCell {
    
    var user: User?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(nameLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(15)
            make.top.equalTo(15)
        }
    }
    
    func setup() {
        nameLabel.text = user?.fullName
    }
    
}
