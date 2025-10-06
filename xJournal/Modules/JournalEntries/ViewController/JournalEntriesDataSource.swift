//
//  JournalEntriesDataSource.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

@MainActor
final class JournalEntriesDataSource: NSObject {

    var didTapEdit: ((JournalEntry) -> Void)?

    private var tableView: UITableView!
    private var entries = [JournalEntry]()

    func configure(_ tableView: UITableView, footerHeight: CGFloat) {
        self.tableView = tableView
        tableView.register(JournalEntriesHeaderView.self)
        tableView.register(JournalEntryCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = .clear
        tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: footerHeight - 40, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: footerHeight - 40, right: -10)
        tableView.sectionFooterHeight = .leastNonzeroMagnitude
    }

    func render(_ entries: [JournalEntry]) {
        self.entries = entries
        tableView.reloadData()
    }

    func insert(_ entry: JournalEntry) {
        if let index = entries.firstIndex(of: entry) {
            entries.remove(at: index)
            entries.insert(entry, at: index)
            tableView.reloadData()
            return
        }
        entries.insert(entry, at: .zero)
        tableView.reloadData()
    }

    func delete(_ entry: JournalEntry) {
        guard let index = entries.firstIndex(of: entry) else {
            return
        }
        entries.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

extension JournalEntriesDataSource: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: JournalEntryCell = tableView.dequeueReusableCell(at: indexPath),
              let entry = entries[safe: indexPath.row] else {
            fatalError()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.delegate = self
        cell.render(title: entry.title)
        cell.render(text: entry.body)
        return cell
    }
}

extension JournalEntriesDataSource: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? JournalEntryCell else {
            return
        }
        cell.updateBottomSeparator(height: 0.33)
    }

    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath) else {
            return nil
        }

        let bookmarkAction = UIContextualAction(style: .normal, title: nil) { _, view, completion in
            print("Bookmark")
            completion(true)
        }
        bookmarkAction.backgroundColor = .white.withAlphaComponent(0)
        bookmarkAction.image = UIImage(systemName: "bookmark.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))?
            .withTintColor(.systemPink, renderingMode: .alwaysOriginal)
            .withBaselineOffset(fromBottom: centerOffset(of: cell, in: tableView)?.dy ?? .zero)

        return UISwipeActionsConfiguration(actions: [bookmarkAction])
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard let cell = tableView.cellForRow(at: indexPath), let entry = entries[safe: indexPath.row] else {
            return nil
        }

        let editAction = UIContextualAction(style: .normal, title: nil) { [unowned self] _, _, completion in
            didTapEdit?(entry)
            completion(true)
        }
        editAction.backgroundColor = .white.withAlphaComponent(.zero)
        editAction.image = UIImage(systemName: "pencil.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))?
            .withTintColor(.systemIndigo, renderingMode: .alwaysOriginal)
            .withBaselineOffset(fromBottom: centerOffset(of: cell, in: tableView)?.dy ?? .zero)

        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [unowned self] _, _, completion in
            delete(entry)
            completion(true)
        }
        deleteAction.backgroundColor = .white.withAlphaComponent(.zero)
        deleteAction.image = UIImage(systemName: "trash.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))?
            .withTintColor(.red, renderingMode: .alwaysOriginal)
            .withBaselineOffset(fromBottom: centerOffset(of: cell, in: tableView)?.dy ?? .zero)

        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        guard let entry = entries[safe: indexPath.row] else {
            return nil
        }

        let editAction = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [unowned self] _ in didTapEdit?(entry) }
        let bookmarkAction = UIAction(title: "Bookmark", image: UIImage(systemName: "bookmark")) { _ in print("Bookmark") }
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [unowned self] _ in delete(entry) }
        let deleteMenu = UIMenu(options: .displayInline, children: [deleteAction])
        let contextMenu = UIMenu(children: [editAction, bookmarkAction, deleteMenu])

        return UIContextMenuConfiguration(identifier: indexPath as NSCopying, actionProvider: { _ in contextMenu })
    }

    func tableView(_ tableView: UITableView, previewForHighlightingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) as? JournalEntryCell else {
            return nil
        }
        return UITargetedPreview(view: cell.contentStackView)
    }

    func tableView(_ tableView: UITableView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        guard let indexPath = configuration.identifier as? IndexPath,
              let cell = tableView.cellForRow(at: indexPath) as? JournalEntryCell else {
            return nil
        }
        return UITargetedPreview(view: cell.contentStackView)
    }
}

extension JournalEntriesDataSource: JournalEntryCellDelegate {

    func didTapTextView(cell: JournalEntryCell) {
        guard cell.isExpandable, let tableView, let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        tableView.isUserInteractionEnabled = false

        UIView.animate(withDuration: 0.3) { [unowned self] in
            if !isTopPointVisibleInWindow(for: cell) {
                let rect = tableView.rectForRow(at: indexPath)
                tableView.setContentOffset(CGPoint(x: 0, y: rect.minY), animated: false)
            }
            tableView.performBatchUpdates {
                cell.toggleExpandedState()
                cell.hideTextChevronImage()
                cell.layoutIfNeeded()
            }
        } completion: { _ in
            if !cell.isExpanded { cell.showTextChevronImageIfAble() }
            tableView.isUserInteractionEnabled = true
        }
    }
}

private extension JournalEntriesDataSource {

    func centerOffset(of cell: UITableViewCell, in tableView: UITableView) -> CGVector? {
        let cellCenter = CGPoint(x: cell.frame.midX, y: cell.frame.midY)
        let cellFrame = tableView.convert(cell.frame, to: tableView)
        let visibleRect = CGRect(origin: tableView.contentOffset, size: tableView.bounds.size)

        guard let intersection = cellFrame.intersection(visibleRect).isNull ? nil : cellFrame.intersection(visibleRect) else {
            return nil
        }

        let visibleCenter = CGPoint(x: intersection.midX, y: intersection.midY)

        return CGVector(dx: visibleCenter.x - cellCenter.x, dy: visibleCenter.y - cellCenter.y)
    }

    func isTopPointVisibleInWindow(for cell: UITableViewCell) -> Bool {
        guard let window = cell.window else {
            return false
        }
        let cellFrameInWindow = cell.convert(cell.bounds, to: window)
        let topPoint = CGPoint(x: cellFrameInWindow.minX, y: cellFrameInWindow.minY)
        return window.bounds.contains(topPoint)
    }
}
