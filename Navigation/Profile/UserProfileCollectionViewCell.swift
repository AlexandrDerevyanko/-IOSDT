//
//import Foundation
//import UIKit
//
//class UserProfileCollectionViewCell: UICollectionViewCell {
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupUI()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private let textLabel: UILabel = {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private func setupUI() {
//        addSubview(textLabel)
//        setupConstraints()
//    }
//    
//    private func setupConstraints() {
//        textLabel.snp.makeConstraints { make in
//            make.left.equalTo(6)
//            make.right.equalTo(6)
//            make.top.equalTo(6)
//            make.bottom.equalTo(6)
//        }
//    }
//    
//    func setup(text: String) {
//        textLabel.text = text
//    }
//    
//}
