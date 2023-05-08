
import UIKit

class FeedViewController: UIViewController {
    
//    private let viewModel: FeedViewModelProtocol

    private lazy var feedView = FeedView(delegate: self)
    
    
//    init(viewModel: FeedViewModelProtocol) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
    
//    @available(*, unavailable)
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func loadView() {
        super.loadView()
        view = feedView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        title = "Feed"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .systemGray6
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
}

extension FeedViewController: FeedViewDelegate {
    
    func postButtonPressed() {
        let viewControllerToPush = PostViewController()
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
    func infoButtonPressed() {
        let networkService = NetworkService()
        let viewControllerToPush = InfoViewController(networkService: networkService)
        navigationController?.pushViewController(viewControllerToPush, animated: true)
    }
    
}
