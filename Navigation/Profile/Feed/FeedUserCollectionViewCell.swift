
import UIKit

class FeedUserCollectionViewCell: UICollectionViewCell {
    
    private let image: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 30
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "1234"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 15
        clipsToBounds = true
        setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setup(img: UIImage?, name: String?) {
        image.image = img
        nameLabel.text = name
    }
        
    private func setupUI() {
        backgroundColor = .white
        addSubview(image)
        addSubview(nameLabel)
        setupConstraints()
    }
    
    private func setupConstraints() {
        image.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.centerX.equalTo(snp.centerX)
            make.width.equalTo(60)
            make.height.equalTo(60)
//            make.left.equalTo(8)
//            make.right.equalTo(-8)
//            make.bottom.equalTo(-8)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(8)
            make.centerX.equalTo(snp.centerX)
        }
    }

}
