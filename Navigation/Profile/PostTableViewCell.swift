
import UIKit

class PostTableViewCell: UITableViewCell {
    
    struct ViewModel {
        var author: String
        var description: String
        var image: UIImage?
        var likes: Int
        var views: Int
    }
    
    private let images: UIImageView = {
        let images = UIImageView()
        images.backgroundColor = .black
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
        setupView()
        #if DEBUG
//        backgroundColor = .cyan
        #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup (with viewModel: ViewModel) {
        images.image = viewModel.image
        authors.text = viewModel.author
        descriptions.text = viewModel.description
        likes.text = "Likes: \(viewModel.likes)"
        views.text = "Views: \(viewModel.views)"
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
    
}
