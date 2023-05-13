import Foundation

protocol FeedViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((FeedViewModel.State) -> Void)? { get set }
    func updateState(viewInput: FeedViewModel.ViewInput)
}

final class FeedViewModel: FeedViewModelProtocol {
    enum State {
        case initial
        case checkTrue
        case checkFalse
        case error(Error)
    }

    enum ViewInput {
        case check(String)
        case pushInfoViewController
        case pushPostViewController
    }

    weak var coordinator: FeedCoordinator?
    var onStateDidChange: ((State) -> Void)?
    

    private(set) var state: State = .initial {
        didSet {
            onStateDidChange?(state)
        }
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case let .check(text):
            if CheckService.defaultCheckService.check(text: text) {
                state = .checkTrue
            } else {
                state = .checkFalse
            }
        case .pushInfoViewController:
            coordinator?.pushInfoViewController()
        case .pushPostViewController:
            coordinator?.pushPostViewController()
        }
    }
}

