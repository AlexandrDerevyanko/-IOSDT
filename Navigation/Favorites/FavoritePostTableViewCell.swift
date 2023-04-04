//
//  FavoritePostTableViewCell.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 04.04.2023.
//

import UIKit
import SnapKit

class FavoritePostTableViewCell: UITableViewCell {
    
    var post: Post!
    var delegate: ProfileDelegate?
    
    private let images: UIImageView = {
        let images = UIImageView()
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    private let authors: UILabel = {
        let authors = UILabel()
        authors.font = UIFont.boldSystemFont(ofSize: 20)
        authors.textColor = .black
        authors.numberOfLines = 2
        authors.translatesAutoresizingMaskIntoConstraints = false
        return authors
    }()
    
    private let descriptions: UILabel = {
        let descriptions = UILabel()
        descriptions.font = UIFont.systemFont(ofSize: 14)
        descriptions.textColor = .systemGray
        descriptions.numberOfLines = 0
        descriptions.translatesAutoresizingMaskIntoConstraints = false
        return descriptions
    }()
    
    private let likes: UILabel = {
        let likes = UILabel()
        likes.font = UIFont.systemFont(ofSize: 16)
        likes.textColor = .black
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()
    
    private let views: UILabel = {
        let views = UILabel()
        views.font = UIFont.systemFont(ofSize: 16)
        views.textColor = .black
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSingleAndDoubleTapGesture()
        setupView()
        #if DEBUG
//        backgroundColor = .cyan
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup () {
        if post.image != nil {
            images.image = UIImage(data: post.image!)
        }
        authors.text = post.author
        descriptions.text = post.text
        likes.text = "Likes: \(post.likes)"
        views.text = "Views: \(post.views)"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        images.image = nil
        authors.text = nil
        descriptions.text = nil
        likes.text = nil
        views.text = nil
    }
    
    private func setupView() {
        addSubview(images)
        addSubview(authors)
        addSubview(descriptions)
        addSubview(likes)
        addSubview(views)
        
        NSLayoutConstraint.activate([
            
            authors.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            authors.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            authors.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            authors.heightAnchor.constraint(equalToConstant: 30),

            images.topAnchor.constraint(equalTo: authors.bottomAnchor, constant: 16),
            images.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            images.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            images.heightAnchor.constraint(equalTo: images.widthAnchor, multiplier: 1),

            descriptions.topAnchor.constraint(equalTo: images.bottomAnchor, constant: 16),
            descriptions.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            descriptions.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

            likes.topAnchor.constraint(equalTo: descriptions.bottomAnchor, constant: 16),
            likes.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            likes.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),

            views.topAnchor.constraint(equalTo: descriptions.bottomAnchor, constant: 16),
            views.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            views.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
        
    }
    
    private func addSingleAndDoubleTapGesture() {
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTap))
        singleTapGesture.numberOfTapsRequired = 1
        self.addGestureRecognizer(singleTapGesture)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(doubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)

        singleTapGesture.require(toFail: doubleTapGesture)
    }

    @objc private func singleTap(_ tapGesture: UITapGestureRecognizer) {
        delegate?.changePost(post: post)
    }

    @objc private func doubleTap(_ tapGesture: UITapGestureRecognizer) {
        delegate?.likePost(post: post)
    }
    
}
