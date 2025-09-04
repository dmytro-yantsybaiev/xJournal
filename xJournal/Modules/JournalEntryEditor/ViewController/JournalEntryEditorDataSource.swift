//
//  JournalEntryEditorDataSource.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 31.08.2025.
//

import UIKit

@MainActor
final class JournalEntryEditorDataSource: NSObject {

    enum Section: Int {
        case media
        case text
    }

    enum Entry: Hashable {

        case title
        case body

        var id: String {
            switch self {
            case .title: "title"
            case .body: "body"
            }
        }

        var font: UIFont {
            switch self {
            case .title: .preferredFont(forTextStyle: .headline)
            case .body: .preferredFont(forTextStyle: .body)
            }
        }

        var textColor: UIColor {
            switch self {
            case .title: .label
            case .body: .label
            }
        }

        var placeholderText: String? {
            switch self {
            case .title: "Title"
            case .body: "Start writing..."
            }
        }

        var placeholderFont: UIFont {
            switch self {
            case .title: .preferredFont(forTextStyle: .headline)
            case .body: .preferredFont(forTextStyle: .body)
            }
        }

        var placeholderTextColor: UIColor {
            switch self {
            case .title: .lightGray
            case .body: .lightGray
            }
        }
    }

    var textForEntry: ((Entry) -> String?)?
    var textDidChangeForEntry: ((Entry, String) -> Void)?

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Entry>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Entry>!
    private var entryTextView = [Entry: UITextView]()

    func configure(_ collectionView: UICollectionView) {
        self.collectionView = collectionView

        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .clear
        configuration.separatorConfiguration.bottomSeparatorInsets = .zero

        snapshot = NSDiffableDataSourceSnapshot<Section, Entry>()

        dataSource = UICollectionViewDiffableDataSource<Section, Entry>(collectionView: collectionView) { [unowned self] collectionView, indexPath, entry in
            let section = dataSource.sectionIdentifier(for: indexPath.section)!
            let cell: JournalEntryTextCell = collectionView.dequeueReusableCell(at: indexPath)!

            switch section {
            case .media:
                break
            case .text:
                var configuration = JournalEntryTextCell.Configuration()
                configuration.backgroundColor = .clear
                configuration.text = textForEntry?(entry)
                configuration.font = entry.font
                configuration.textColor = entry.textColor
                configuration.placeholderText = entry.placeholderText
                configuration.placeholderFont = entry.placeholderFont
                configuration.placeholderTextColor = entry.placeholderTextColor
                cell.delegate = self
                cell.itemIdentifierType = entry
                cell.apply(configuration)
                entryTextView[entry] = cell.textView
            }

            return cell
        }

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        collectionView.setCollectionViewLayout(layout, animated: true)
        collectionView.dataSource = dataSource
        collectionView.register(JournalEntryTextCell.self)
        collectionView.backgroundColor = .secondarySystemGroupedBackground
        collectionView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    }

    func append(_ entries: [Entry], section: Section) {
        snapshot.appendSections([section])
        snapshot.appendItems(entries, toSection: section)
        dataSource.apply(snapshot)
    }

    func insert(_ entry: Entry, before beforeEntry: Entry) {
        snapshot.insertItems([entry], beforeItem: beforeEntry)
        dataSource.apply(snapshot)
    }

    func delete(_ entry: Entry) {
        snapshot.deleteItems([entry])
        dataSource.apply(snapshot)
    }
}

extension JournalEntryEditorDataSource: JournalEntryTextCellDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, itemIdentifierType: (any Hashable & Sendable)?) -> Bool {
        guard let entry = snapshot.itemIdentifiers(inSection: .text).first(where: { $0.hashValue == itemIdentifierType?.hashValue }),
              let bodyTextView = entryTextView[.body],
              entry == .title else {
            return true
        }

        guard text == "\n" else {
            return true
        }

        bodyTextView.becomeFirstResponder()
        return false
    }

    func textViewDidChange(_ textView: UITextView, itemIdentifierType: (any Hashable & Sendable)?) {
        UIView.setAnimationsEnabled(false)
        collectionView.performBatchUpdates(nil) { [unowned self] _ in
            guard let entry = snapshot.itemIdentifiers(inSection: .text).first(where: { $0.hashValue == itemIdentifierType?.hashValue }) else {
                return
            }
            textDidChangeForEntry?(entry, textView.text)
        }
        UIView.setAnimationsEnabled(true)
    }
}
