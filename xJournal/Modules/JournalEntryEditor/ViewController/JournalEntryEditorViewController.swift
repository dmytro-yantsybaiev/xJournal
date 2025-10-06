//
//  JournalEntryEditorViewController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 27.08.2025.
//

import UIKit
import Combine

final class JournalEntryEditorViewController: BaseViewController {

    @IBOutlet private weak var controller: JournalEntryEditorController!

    var viewModel: JournalEntryEditorViewModel!

    private let didTapBookmarkPassthroughSubject = PassthroughSubject<Void, Never>()
    private let didTapHideShowTitlePassthroughSubject = PassthroughSubject<Void, Never>()
    private let didTapDeletePassthroughSubject = PassthroughSubject<Void, Never>()
    private let didTapDonePassthroughSubject = PassthroughSubject<Void, Never>()
    private let textDidChangePassthroughSubject = PassthroughSubject<(JournalEntryEditorDataSource.Item, String), Never>()

    private lazy var hideShowTitleAction: UIAction = {
        let action = UIAction { [unowned self] _ in didTapHideShowTitlePassthroughSubject.send() }
        action.title = "Hide Title"
        action.image = UIImage(systemName: "eye.slash")
        return action
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        sendViewDidLoad()
    }

    override func configure() {
        super.configure()
        configureNavigationBar()
        controller.delegate = self
        controller.configure()
    }

    override func bind() {
        let input = JournalEntryEditorViewModel.Input(
            viewDidLoadPublisher: viewDidLoadPassthroughSubject.eraseToAnyPublisher(),
            didTapBookmarkPublisher: didTapBookmarkPassthroughSubject.eraseToAnyPublisher(),
            didTapHideShowTitlePublisher: didTapHideShowTitlePassthroughSubject.eraseToAnyPublisher(),
            didTapDeletePublisher: didTapDeletePassthroughSubject.eraseToAnyPublisher(),
            didTapDonePublisher: didTapDonePassthroughSubject.eraseToAnyPublisher(),
            textDidChangePublisher: textDidChangePassthroughSubject.eraseToAnyPublisher(),
        )
        let output = viewModel.bind(input)

        output
            .renderBookmarkButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned controller] isBookmarked in
                controller?.bookmarkButton.image = UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                controller?.bookmarkButton.tintColor = isBookmarked ? .systemPink : .systemIndigo
            }
            .store(in: &cancellables)

        output
            .renderHideShowTitleActionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned hideShowTitleAction] isTitleHidden in
                hideShowTitleAction.title = isTitleHidden ? "Show Title" : "Hide Title"
                hideShowTitleAction.image = UIImage(systemName: isTitleHidden ? "eye" : "eye.slash")
            }
            .store(in: &cancellables)

        output
            .becomeFirstResponderForItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned controller] item in controller?.dataSource.becomeFirstResponder(for: item) }
            .store(in: &cancellables)

        output
            .appendItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned controller] items in controller?.dataSource.append(items, section: .text) }
            .store(in: &cancellables)

        output
            .insertItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned controller] item, beforeEntry in controller?.dataSource.insert(item, before: beforeEntry) }
            .store(in: &cancellables)

        output
            .deleteItemPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned controller] item in controller?.dataSource.delete(item) }
            .store(in: &cancellables)
    }
}

extension JournalEntryEditorViewController: JournalEntryEditorControllerDelegate {

    func text(for item: JournalEntryEditorDataSource.Item) -> String? {
        viewModel.itemText[item]
    }
    
    func textDidChange(for item: JournalEntryEditorDataSource.Item, text: String) {
        textDidChangePassthroughSubject.send((item, text))
    }
}

private extension JournalEntryEditorViewController {

    func configureNavigationBar() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, MMM d"
        navigationController?.navigationBar.backgroundColor = .secondarySystemGroupedBackground
        navigationItem.title = dateFormatter.string(from: viewModel.journalEntry.timestamp)

        controller.bookmarkButton.primaryAction = UIAction { [unowned self] _ in didTapBookmarkPassthroughSubject.send() }
        controller.doneButton.primaryAction = UIAction { [unowned self] _ in didTapDonePassthroughSubject.send() }
        controller.menuButton.menu = UIMenu(children: [
            UIDeferredMenuElement { [unowned self] elementProvider in
                elementProvider([
                    hideShowTitleAction,
                    UIAction(title: "Delete", attributes: .destructive) { [unowned self] _ in didTapDeletePassthroughSubject.send() }
                ])
            }
        ])

        navigationItem.leftBarButtonItem = controller.bookmarkButton
        navigationItem.rightBarButtonItems = [
            controller.doneButton,
            .fixedSpace(10),
            controller.menuButton,
        ]
    }
}
