
import UIKit
import iOSIntPackage

class FeedFirstSectionTableViewCell: UITableViewCell {
    
    var users: [User]?

    private lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return layout
    }()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FeedUserCollectionViewCell.self, forCellWithReuseIdentifier: "FeedUserCell")
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "DefaultCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("photos-label-profileVC-localizable", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.right"), for: [])
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .systemBackground
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        backgroundColor = UIColor.createColor(lightMode: .white, darkMode: .systemGray3)
        contentView.addSubview(collectionView)
        setupConstraints()
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(snp.left)
            make.right.equalTo(snp.right)
            make.top.equalTo(snp.top)
            make.bottom.equalTo(snp.bottom)
        }
    }
}

extension FeedFirstSectionTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    private enum Constants {
        static var numberOfItemsInLIne: CGFloat {
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let users, users.count <= 30 {
            return users.count
        } else {
            return 30
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeedUserCell", for: indexPath) as? FeedUserCollectionViewCell else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DefaultCell", for: indexPath)
            return cell
        }
        
        cell.setup(img: UIImage(data: users?[indexPath.row].avatar ?? Data()), name: users?[indexPath.row].fullName)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.sectionInset ?? .zero
        let interItemSpacing = (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.minimumInteritemSpacing ?? 0

        let width = collectionView.frame.width - (Constants.numberOfItemsInLIne - 1) * interItemSpacing - insets.left - insets.right

        let itemWidth = floor(width / Constants.numberOfItemsInLIne)

        return CGSize(width: itemWidth, height: collectionView.frame.height - interItemSpacing)
    }

}
