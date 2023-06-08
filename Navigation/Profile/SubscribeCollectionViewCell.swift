//
//import Foundation
//import UIKit
//
//class SubscribeCollectionViewCell: UICollectionViewCell {
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
//    private let subscribeButton: BlueButton = {
//        let button = BlueButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    
//    private func setupUI() {
//        addSubview(subscribeButton)
//        setupConstraints()
//    }
//    
//    private func setupConstraints() {
//        subscribeButton.snp.makeConstraints { make in
//            make.left.equalTo(6)
//            make.right.equalTo(6)
//            make.top.equalTo(6)
//            make.bottom.equalTo(6)
//        }
//    }
//    
//    func setup(isSubscribe: Bool) {
//        isSubscribe ? subscribeButton.setTitle("Subscrube", for: .normal) : subscribeButton.setTitle("Unsubscribe", for: .normal)
//    }
//    
//}
