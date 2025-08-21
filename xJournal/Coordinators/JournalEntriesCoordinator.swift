//
//  JournalEntriesCoordinator.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit

final class JournalEntriesCoordinator: BaseCoordinator, Router.StartFlowRoute {

    func start(completion: (() -> Void)?) {
        let viewController = JournalEntriesViewController.storyboard
        let viewModel = JournalEntriesViewModel()
        viewController.viewModel = viewModel
        set(root: viewController, animated: true)
        completion?()
    }
}
