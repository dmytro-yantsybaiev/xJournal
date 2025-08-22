//
//  JournalEntriesDataSource.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

@MainActor
final class JournalEntriesDataSource: NSObject {

    private var tableView: UITableView?
    private var entries = [JournalEntry]()

    func configure(_ tableView: UITableView, footerHeight: CGFloat) {
        self.tableView = tableView
        tableView.register(JournalEntryCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: footerHeight - 20, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: footerHeight - 20, right: 0)
    }

    func render(entries: [JournalEntry]) {
        self.entries = entries
        tableView?.reloadData()
    }
}

extension JournalEntriesDataSource: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: JournalEntryCell = tableView.dequeueReusableCell(at: indexPath),
              let entry = entries[safe: indexPath.row] else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.delegate = self
        cell.titleLabel.text = entry.title
        cell.textTextView.text = entry.text
        return cell
    }
}

extension JournalEntriesDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let bookmarkAction = UIContextualAction(style: .normal, title: nil, handler: { _, _, completion in
            print("Bookmark")
            completion(true)
        })
//        bookmarkAction.backgroundColor = .white.withAlphaComponent(0)
        bookmarkAction.image = UIImage(systemName: "bookmark")

        return UISwipeActionsConfiguration(actions: [bookmarkAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: nil, handler: { _, _, completion in
            print("Edit")
            completion(true)
        })
//        editAction.backgroundColor = .white.withAlphaComponent(0)
        editAction.image = UIImage(systemName: "pencil")


        let deleteAction = UIContextualAction(style: .destructive, title: nil, handler: { _, _, completion in
            print("Delete")
            completion(true)
        })
//        deleteAction.backgroundColor = .white.withAlphaComponent(0)
        deleteAction.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        UIContextMenuConfiguration(identifier: indexPath as NSCopying, actionProvider: {_ in
            UIMenu(children: [
                UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { _ in print("Edit") },
                UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { _ in print("Bookmark") },
                UIMenu(options: .displayInline, children: [
                    UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { _ in print("Delete") }
                ])
            ])
        })
    }

    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) as? JournalEntryCell else {
            return nil
        }
        return preview(for: cell)
    }

    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) as? JournalEntryCell else {
            return nil
        }
        return preview(for: cell)
    }

    private func preview(for cell: JournalEntryCell) -> UITargetedPreview? {
        guard let snapshot = cell.contentStackView.snapshotView(afterScreenUpdates: false) else {
            return nil
        }

        let parameters = UIPreviewParameters()
        parameters.visiblePath = UIBezierPath(roundedRect: cell.contentStackView.bounds, cornerRadius: cell.contentStackView.layer.cornerRadius)
        parameters.backgroundColor = .clear

        let previewTarget = UIPreviewTarget(
            container: cell.contentStackView,
            center: CGPoint(x: cell.contentStackView.bounds.midX, y: cell.contentStackView.bounds.midY)
        )

        return UITargetedPreview(view: snapshot, parameters: parameters, target: previewTarget)
    }
}

extension JournalEntriesDataSource: UITableViewCellDelegate {

    func contentDidChange(cell: UITableViewCell) {
        UIView.animate(springDuration: 0.2) {
            tableView?.performBatchUpdates { cell.contentView.layoutIfNeeded() }
        }
    }
}
