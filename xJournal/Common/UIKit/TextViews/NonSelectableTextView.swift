//
//  NonSelectableTextView.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 22.08.2025.
//

import UIKit

final class NonSelectableTextView: UITextView {

    // Disable selection handles
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        return []
    }

    // Disable copy/paste menu
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
