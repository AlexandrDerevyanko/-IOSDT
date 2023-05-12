
import UIKit

class FeedViewController: UIViewController {
    
    private let viewModel: FeedViewModelProtocol

    private lazy var feedView = FeedView(delegate: self)
    
    
    init(viewModel: FeedViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = feedView
        bindViewModel()
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
    
    func bindViewModel() {
        viewModel.onStateDidChange = { [weak self] state in
            guard let self = self else {
                return
            }
            switch state {
            case .initial:
                ()
            case .checkTrue:
                self.feedView.check(status: true)
            case .checkFalse:
                self.feedView.check(status: false)
            case .error:
                ()
            }
        }
    }
    
}

extension FeedViewController: FeedViewDelegate {
    
    func postButtonPressed() {
        viewModel.updateState(viewInput: .pushPostViewController)
    }
    
    func infoButtonPressed() {
        viewModel.updateState(viewInput: .pushInfoViewController)
    }
    
    func checkGuessButtonPressed(text: String) {
        viewModel.updateState(viewInput: .check(text))
    }
    
}
