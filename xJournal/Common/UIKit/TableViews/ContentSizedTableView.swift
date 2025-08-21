//
//  ContentSizedTableView.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

final class ContentSizedTableView: UITableView {

    /// To remove any height constraints, set the value of this property to 0
    var maxVisibleRows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var contentSize: CGSize {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()

        guard maxVisibleRows > 0 else {
            return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
        }

        var totalHeight: CGFloat = 0
        let section = 0
        let maxRows = min(maxVisibleRows, numberOfRows(inSection: section))

        if rectForHeader(inSection: section).height > 0 {
            totalHeight += rectForHeader(inSection: section).height
        }

        if rectForFooter(inSection: section).height > 0 {
            totalHeight += rectForFooter(inSection: section).height
        }

        for row in 0 ..< maxRows {
            let indexPath = IndexPath(row: row, section: section)
            let rowRect = rectForRow(at: indexPath)
            totalHeight += rowRect.height
        }

        return CGSize(width: UIView.noIntrinsicMetric, height: totalHeight)
    }
}
