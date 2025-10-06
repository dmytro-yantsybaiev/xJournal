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

    enum Item: Hashable {

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

    var textForItem: ((Item) -> String?)?
    var textDidChangeForItem: ((Item, String) -> Void)?

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Item>!
    private var itemTextView = [Item: UITextView]()

    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func configure(_ collectionView: UICollectionView) {
        self.collectionView = collectionView

        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.backgroundColor = .clear
        configuration.separatorConfiguration.bottomSeparatorInsets = .zero

        snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) { [unowned self] collectionView, indexPath, item in
            let section = dataSource.sectionIdentifier(for: indexPath.section)!
            let cell: JournalEntryTextCell = collectionView.dequeueReusableCell(at: indexPath)!

            switch section {
            case .media:
                break
            case .text:
                var configuration = JournalEntryTextCell.Configuration()
                configuration.backgroundColor = .clear
                configuration.text = textForItem?(item)
                configuration.font = item.font
                configuration.textColor = item.textColor
                configuration.placeholderText = item.placeholderText
                configuration.placeholderFont = item.placeholderFont
                configuration.placeholderTextColor = item.placeholderTextColor
                cell.delegate = self
                cell.itemIdentifierType = item
                cell.apply(configuration)
                itemTextView[item] = cell.textView
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

    func append(_ items: [Item], section: Section) {
        snapshot.appendSections([section])
        snapshot.appendItems(items, toSection: section)
        dataSource.apply(snapshot)
    }

    func insert(_ item: Item, before beforeItem: Item) {
        snapshot.insertItems([item], beforeItem: beforeItem)
        dataSource.apply(snapshot)
    }

    func delete(_ item: Item) {
        snapshot.deleteItems([item])
        dataSource.apply(snapshot)
    }

    func becomeFirstResponder(for item: Item) {
        DispatchQueue.main.async { [unowned self] in
            itemTextView[item]?.becomeFirstResponder()
        }
    }
}

extension JournalEntryEditorDataSource: JournalEntryTextCellDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, itemIdentifierType: (any Hashable & Sendable)?) -> Bool {
        guard let item = snapshot.itemIdentifiers(inSection: .text).first(where: { $0.hashValue == itemIdentifierType?.hashValue }),
              item == .title else {
            return true
        }

        guard text == "\n" else {
            return true
        }

        itemTextView[.body]?.becomeFirstResponder()
        return false
    }

    func textViewDidChange(_ textView: UITextView, itemIdentifierType: (any Hashable & Sendable)?) {
        UIView.setAnimationsEnabled(false)
        collectionView.performBatchUpdates(nil) { [unowned self] _ in
            guard let item = snapshot.itemIdentifiers(inSection: .text).first(where: { $0.hashValue == itemIdentifierType?.hashValue }) else {
                return
            }
            textDidChangeForItem?(item, textView.text)
        }
        UIView.setAnimationsEnabled(true)
    }
}

private extension JournalEntryEditorDataSource {

    @objc func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        collectionView.contentInset.bottom = frame.height
        collectionView.verticalScrollIndicatorInsets.bottom = frame.height
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        collectionView.contentInset.bottom = 0
        collectionView.verticalScrollIndicatorInsets.bottom = 0
    }
}
