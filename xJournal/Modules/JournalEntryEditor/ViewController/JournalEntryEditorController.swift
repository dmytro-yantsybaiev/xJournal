//
//  JournalEntryEditorController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 31.08.2025.
//

import UIKit

@MainActor
protocol JournalEntryEditorControllerDelegate: AnyObject {
    func text(for item: JournalEntryEditorDataSource.Item) -> String?
    func textDidChange(for item: JournalEntryEditorDataSource.Item, text: String)
}

@MainActor
final class JournalEntryEditorController: NSObject {

    @IBOutlet private(set) weak var dataSource: JournalEntryEditorDataSource!
    @IBOutlet private weak var collectionView: UICollectionView!

    private(set) lazy var bookmarkButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: nil, image: UIImage(systemName: "bookmark"))
        button.tintColor = .systemIndigo
        return button
    }()

    private(set) lazy var menuButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis.circle"))
        button.tintColor = .systemIndigo
        return button
    }()

    private(set) lazy var doneButton: UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .done)
        button.tintColor = .systemIndigo
        return button
    }()

    weak var delegate: JournalEntryEditorControllerDelegate?

    func configure() {
        configureDataSource()
    }
}

private extension JournalEntryEditorController {

    func configureDataSource() {
        dataSource.configure(collectionView)

        dataSource.textForItem = { [unowned self] item in
            delegate?.text(for: item)
        }

        dataSource.textDidChangeForItem = { [unowned self] item, text in
            delegate?.textDidChange(for: item, text: text)
        }
    }
}
