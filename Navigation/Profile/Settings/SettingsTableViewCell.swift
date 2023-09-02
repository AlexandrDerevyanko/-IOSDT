//
import UIKit

class SettingsTableViewCell: UITableViewCell {

    var textDescription: String?
    var text: String?
    var isChangePassword: Bool?
    var delegate: SettingsViewDelegate?

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray3
        textField.layer.cornerRadius = 5
        textField.clipsToBounds = true
        textField.borderStyle = .roundedRect
        textField.textAlignment = .center
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(textField)
        setupConstraints()
    }

    private func setupConstraints() {
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(16)
            make.centerY.equalTo(snp.centerY)
        }
        textField.snp.makeConstraints { make in
            make.right.equalTo(-16)
            make.centerY.equalTo(snp.centerY)
            make.left.equalTo(descriptionLabel.snp.right).offset(16)
            make.width.equalTo(140)
        }
    }

    func setup () {
        descriptionLabel.text = textDescription
        textField.text = text
        
        if let isChangePassword {
            if isChangePassword {
                textField.isSecureTextEntry = true
            }
        }
        textField.addTarget(self, action: #selector(saveText), for: .allEditingEvents)
    }
    
    @objc
    private func saveText() {
        if let isChangePassword {
            if isChangePassword {
                if textField.tag == 0 {
                    delegate?.savePassword(password: textField.text)
                } else if textField.tag == 1 {
                    delegate?.saveConfirmedPassword(confirmedPassword: textField.text)
                }
            }
        } else {
            delegate?.saveName(name: textField.text)
        }
        
    }

}
