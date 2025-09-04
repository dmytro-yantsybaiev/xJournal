//
//  JournalEntryEditorController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 31.08.2025.
//

import UIKit

@MainActor
protocol JournalEntryEditorControllerDelegate: AnyObject {
    func text(for entry: JournalEntryEditorDataSource.Entry) -> String?
    func textDidChange(for entry: JournalEntryEditorDataSource.Entry, text: String)
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
//    private(set) lazy var doneButton: UIButton = {
//        let button = UIButton()
//        button.setImage(UIImage(systemName: "ellipsis.circle"), for: .normal)
//        button.tintColor = .systemIndigo
//        button.addAction(UIAction { [unowned self] _ in delegate?.didTapMenuButton() }, for: .touchUpInside)
//        return button
//    }()

    weak var delegate: JournalEntryEditorControllerDelegate?

    func configure() {
        configureDataSource()
    }
}

private extension JournalEntryEditorController {

    func configureDataSource() {
        dataSource.configure(collectionView)

        dataSource.textForEntry = { [unowned self] entry in
            delegate?.text(for: entry)
        }

        dataSource.textDidChangeForEntry = { [unowned self] entry, text in
            delegate?.textDidChange(for: entry, text: text)
        }
    }
}
