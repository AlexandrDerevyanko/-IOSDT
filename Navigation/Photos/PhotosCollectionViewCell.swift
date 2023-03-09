//
//  PhotosCollectionViewCell.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 02.02.2023.
//

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
        self.setupView()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func setup(with img: UIImage?) {
        self.images.image = img
    }
        
    private func setupView() {
        addSubview(images)
            
        NSLayoutConstraint.activate([
            images.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            images.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            images.rightAnchor.constraint(equalTo: rightAnchor, constant: -8),
            images.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }

}
