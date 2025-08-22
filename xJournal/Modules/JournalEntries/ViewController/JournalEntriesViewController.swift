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
    }

    override func bind() {
        super.bind()

        let input = JournalEntriesViewModel.Input(
            viewDidLoadPublisher: viewDidLoadPassthroughSubject.eraseToAnyPublisher()
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

#Preview {
    let viewController = JournalEntriesViewController.storyboard
    let viewModel = JournalEntriesViewModel()
    viewController.viewModel = viewModel
    return viewController
}
