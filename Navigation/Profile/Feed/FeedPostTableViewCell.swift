
import UIKit
import SnapKit

class FeedPostTableViewCell: UITableViewCell {
    
    var post: Post?
    var delegate: FeedDelegate?
    
    private let image: UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFit
        images.translatesAutoresizingMaskIntoConstraints = false
        return images
    }()
    
    private let author: UILabel = {
        let authors = UILabel()
        authors.font = UIFont.boldSystemFont(ofSize: 20)
        authors.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        authors.numberOfLines = 2
        authors.translatesAutoresizingMaskIntoConstraints = false
        return authors
    }()
    
    private let descriptionLabel: UILabel = {
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
        likes.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        likes.translatesAutoresizingMaskIntoConstraints = false
        return likes
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        button.isUserInteractionEnabled = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let comments: UILabel = {
        let views = UILabel()
        views.font = UIFont.systemFont(ofSize: 16)
        views.textColor = UIColor.createColor(lightMode: .black, darkMode: .white)
        views.translatesAutoresizingMaskIntoConstraints = false
        return views
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        addTargets()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup () {
        if post?.image != nil {
            image.image = UIImage(data: (post?.image)!)
        }
        author.text = post?.author
        descriptionLabel.text = post?.text
        likes.text = "\(NSLocalizedString("likes-profileVC-localizable", comment: "")): \(post?.postLikes?.count ?? 0)"
        comments.text = "Комментарии: \(post?.comments?.count ?? 0)"
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        image.image = nil
//        author.text = nil
//        descriptionLabel.text = nil
//        likes.text = nil
//        views.text = nil
//    }
    
    private func setupUI() {
        backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        contentView.addSubview(image)
        contentView.addSubview(author)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(likes)
        contentView.addSubview(likeButton)
        contentView.addSubview(comments)
        setupConstraints()
    }
    
    private func setupConstraints() {
        author.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.height.equalTo(30)
        }
        image.snp.makeConstraints { make in
            make.top.equalTo(author.snp.bottom).offset(16)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.height.equalTo(image.snp.width).multipliedBy(1)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(16)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
        }
        likes.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        likeButton.snp.makeConstraints { make in
            make.left.equalTo(likes.snp.right).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        comments.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.right.equalTo(contentView.snp.right).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
    
    private func addTargets() {
        likeButton.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        let likesTap = UITapGestureRecognizer(target: self, action: #selector(likesLabelTapped))
        likes.isUserInteractionEnabled = true
        likes.addGestureRecognizer(likesTap)
        let tap = UITapGestureRecognizer(target: self, action: #selector(authorLabelPressed))
        author.isUserInteractionEnabled = true
        author.addGestureRecognizer(tap)
        let commentsTap = UITapGestureRecognizer(target: self, action: #selector(commentsLabelTapped))
        comments.isUserInteractionEnabled = true
        comments.addGestureRecognizer(commentsTap)

    }
    
    @objc
    private func likesLabelTapped(sender: UITapGestureRecognizer) {
        delegate?.pushUsersViewController(post: post, subscribers: nil, subscriptions: nil)
    }
    
    @objc
    private func commentsLabelTapped(sender: UITapGestureRecognizer) {
        delegate?.pushCommentsViewController(post: post ?? Post())
    }
    
    @objc
    private func likeButtonTapped() {
        delegate?.likePost(post: post ?? Post())
    }
    
    @objc func authorLabelPressed(sender:UITapGestureRecognizer) {
        delegate?.authorLabelPressed(user: post?.user ?? User())
    }
    
}
