
import UIKit

class CommentTableViewCell: UITableViewCell {
    
    var comment: Comment?
    
    private let avatar: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 20
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
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
        addSubview(avatar)
        addSubview(nameLabel)
        addSubview(commentLabel)
        addSubview(dateLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        avatar.snp.makeConstraints { make in
            make.left.equalTo(6)
            make.top.equalTo(6)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        nameLabel.snp.makeConstraints { make in
            make.left.equalTo(avatar.snp.right).offset(6)
            make.top.equalTo(6)
        }
        commentLabel.snp.makeConstraints { make in
            make.top.equalTo(avatar.snp.bottom).offset(6)
            make.left.equalTo(6)
            make.bottom.equalTo(-6)
        }
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(6)
            make.right.equalTo(-6)
        }
    }
    
    func setup() {
        avatar.image = UIImage(data: comment?.user?.avatar ?? Data())
        nameLabel.text = comment?.user?.fullName
        commentLabel.text = comment?.text
        let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.locale = .init(identifier: "ru_RU")
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            return formatter
        }()
        dateLabel.text = "\(dateFormatter.string(from: comment?.dateCreated ?? Date()))"
    }
    
}
