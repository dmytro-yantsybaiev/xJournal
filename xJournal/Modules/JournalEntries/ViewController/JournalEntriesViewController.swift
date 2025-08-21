//
//  JournalEntriesViewController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit

final class JournalEntriesViewController: BaseViewController {

    @IBOutlet private weak var controller: JournalEntriesController!

    var viewModel: JournalEntriesViewModel!

    override func configure() {
        super.configure()
        controller.configure()
    }
}

#Preview {
    let viewController = JournalEntriesViewController.storyboard
    let viewModel = JournalEntriesViewModel()
    viewController.viewModel = viewModel
    return viewController
}
