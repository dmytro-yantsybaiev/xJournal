//
//  JournalEntriesCoordinator.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit

final class JournalEntriesCoordinator: BaseCoordinator, Router.StartFlowRoute {

    func start(completion: (() -> Void)?) {
        let viewModel = JournalEntriesViewModel()
        let viewController = JournalEntriesViewController.storyboard
        viewModel.coordinator = self
        viewController.viewModel = viewModel
        set(root: viewController, animated: true)
        completion?()
    }
}

extension JournalEntriesCoordinator: Router.CreateJournalEntryRoute {

    func showCreateJournalEntry(completion: @escaping (JournalEntry) -> Void) {
        let viewModel = CreateJournalEntryViewModel()
        let viewController = CreateJournalEntryViewController.storyboard
        viewController.viewModel = viewModel
        present(viewController, animated: true)
    }
}
