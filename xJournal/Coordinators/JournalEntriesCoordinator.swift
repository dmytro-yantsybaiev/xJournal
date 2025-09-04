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

extension JournalEntriesCoordinator: Router.JournalEntryEditorRoute {

    func showJournalEntryEditor(journalEntry: JournalEntry?, completion: @escaping (JournalEntry?) -> Void) {
        let viewModel = JournalEntryEditorViewModel(journalEntry: journalEntry, completion: completion)
        let viewController = JournalEntryEditorViewController.storyboard
        let navigationController = UINavigationController(rootViewController: viewController)
        viewModel.coordinator = self
        viewController.viewModel = viewModel
        present(navigationController, animated: true)
    }
}
