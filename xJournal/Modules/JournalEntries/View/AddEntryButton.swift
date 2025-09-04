//
//  AddEntryButton.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 21.08.2025.
//

import UIKit

final class AddEntryButton: UIButton {

    override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? backgroundColor?.withAlphaComponent(0.8) : backgroundColor?.withAlphaComponent(1)
        }
    }
}
