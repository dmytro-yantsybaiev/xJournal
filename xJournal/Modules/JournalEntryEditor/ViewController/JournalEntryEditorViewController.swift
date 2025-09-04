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
    private let textDidChangePassthroughSubject = PassthroughSubject<(JournalEntryEditorDataSource.Entry, String), Never>()

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
            .appendEntriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned controller] entries in controller?.dataSource.append(entries, section: .text) }
            .store(in: &cancellables)

        output
            .insertEntryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned controller] entry, beforeEntry in controller?.dataSource.insert(entry, before: beforeEntry) }
            .store(in: &cancellables)

        output
            .deleteEntryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned controller] entry in controller?.dataSource.delete(entry) }
            .store(in: &cancellables)
    }
}

extension JournalEntryEditorViewController: JournalEntryEditorControllerDelegate {

    func text(for entry: JournalEntryEditorDataSource.Entry) -> String? {
        viewModel.entryText[entry]
    }
    
    func textDidChange(for entry: JournalEntryEditorDataSource.Entry, text: String) {
        textDidChangePassthroughSubject.send((entry, text))
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
