
import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        var image: UIImage?
    }
    
    let images: UIImageView = {
        let images = UIImageView()
        images.backgroundColor = .black
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setup(with img: UIImage?) {
        self.images.image = img
    }
        
    private func setupUI() {
        backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        addSubview(images)
        setupConstraints()
    }
    
    private func setupConstraints() {
        images.snp.makeConstraints { make in
            make.top.equalTo(8)
            make.left.equalTo(8)
            make.right.equalTo(-8)
            make.bottom.equalTo(-8)
        }
    }

}
