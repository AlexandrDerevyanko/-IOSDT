import Foundation

protocol FeedViewModelProtocol: ViewModelProtocol {
    var onStateDidChange: ((FeedViewModel.State) -> Void)? { get set }
    func updateState(viewInput: FeedViewModel.ViewInput)
}

final class FeedViewModel: FeedViewModelProtocol {
    enum State {
        case aboutInfo(AboutInfo)
    }

    enum ViewInput {
        case initial
        case aboutInfoButtonDidTap
    }

    struct AboutInfo {
        let buttonTitle: String
        let info: String
    }

    var onStateDidChange: ((State) -> Void)?
    

    private(set) var state: State = .aboutInfo(AboutInfo.makeInfo(isHidden: true)) {
        didSet {
            onStateDidChange?(state)
        }
    }

    func updateState(viewInput: ViewInput) {
        switch viewInput {
        case .initial:
            state = .aboutInfo(AboutInfo.makeInfo(isHidden: true))
        case .aboutInfoButtonDidTap:
            state = .aboutInfo(AboutInfo.makeInfo(isHidden: false))
        }
    }
}

extension FeedViewModel.AboutInfo {
    static var showTitle: String { "Показать" }
    static var hideTitle: String { "Скрыть" }
}

private extension FeedViewModel.AboutInfo {
    static func makeInfo(isHidden: Bool) -> Self {
        let buttonTitle: String = isHidden ? Self.showTitle : Self.hideTitle
        let info: String = isHidden ? "" : "Здесь инфо о приложении"
        return FeedViewModel.AboutInfo(buttonTitle: buttonTitle, info: info)
    }
}
