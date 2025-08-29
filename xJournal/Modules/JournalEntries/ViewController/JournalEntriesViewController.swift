//
//  JournalEntriesViewController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit
import Combine

final class JournalEntriesViewController: BaseViewController {

    @IBOutlet private weak var controller: JournalEntriesController!

    var viewModel: JournalEntriesViewModel!

    private let didTapSearchButtonPassthroughSubject = PassthroughSubject<Void, Never>()
    private let didTapMenuButtonPassthroughSubject = PassthroughSubject<Void, Never>()
    private let didTapAddEndtryButtonPassthroughSubject = PassthroughSubject<Void, Never>()
    private let didBookmarkEntryPassthroughSubject = PassthroughSubject<(UITableView, JournalEntry, IndexPath), Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        sendViewDidLoad()


    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controller.footerView.layer.mask?.frame = controller.footerView.bounds
    }

    override func configure() {
        super.configure()
        controller.configure()
        controller.delegate = self
        configureNavigationBar()
    }

    override func bind() {
        super.bind()

        let input = JournalEntriesViewModel.Input(
            viewDidLoadPublisher: viewDidLoadPassthroughSubject.eraseToAnyPublisher(),
            didTapSearchButtonPublisher: didTapSearchButtonPassthroughSubject.eraseToAnyPublisher(),
            didTapMenuButtonPublisher: didTapMenuButtonPassthroughSubject.eraseToAnyPublisher(),
            didTapAddEndtryButtonPublisher: didTapAddEndtryButtonPassthroughSubject.eraseToAnyPublisher(),
            didBookmarkEntryPublisher: didBookmarkEntryPassthroughSubject.eraseToAnyPublisher(),
        )
        let output = viewModel.transform(input)

        output
            .journalEntriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] journalEntries in
                controller.dataSource.render(entries: journalEntries)
            }
            .store(in: &cancellables)
    }
}

extension JournalEntriesViewController: JournalEntriesControllerDelegate {

    func didTapSearchButton() {
        didTapSearchButtonPassthroughSubject.send()
    }

    func didTapMenuButton() {
        didTapMenuButtonPassthroughSubject.send()
    }

    func didTapAddEntry() {
        didTapAddEndtryButtonPassthroughSubject.send()
    }
}

private extension JournalEntriesViewController {

    func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: controller.navigationBarTitleLabel)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: controller.menuButton),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(customView: controller.searchButton),
        ]
    }
}

#Preview {
    let navigationController = UINavigationController()
    let viewController = JournalEntriesViewController.storyboard
    let viewModel = JournalEntriesViewModel()
    navigationController.setViewControllers([viewController], animated: false)
    viewController.viewModel = viewModel
    return navigationController
}
