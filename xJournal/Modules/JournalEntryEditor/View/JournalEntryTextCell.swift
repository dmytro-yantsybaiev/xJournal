//
//  JournalEntryTextCell.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 31.08.2025.
//

import UIKit

@MainActor
protocol JournalEntryTextCellDelegate: AnyObject {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String, itemIdentifierType: (any Hashable & Sendable)?) -> Bool
    func textViewDidChange(_ textView: UITextView, itemIdentifierType: (any Hashable & Sendable)?)
}

final class JournalEntryTextCell: UICollectionViewListCell {

    struct Configuration {
        var backgroundColor: UIColor?
        var text: String?
        var font: UIFont?
        var textColor: UIColor?
        var placeholderText: String?
        var placeholderFont: UIFont?
        var placeholderTextColor: UIColor?
    }

    @IBOutlet private(set) weak var textView: UITextView!
    @IBOutlet private weak var placeholderTextView: UITextView!
    @IBOutlet private weak var contentStackView: UIStackView!

    weak var delegate: JournalEntryTextCellDelegate?

    var itemIdentifierType: (any Hashable & Sendable)?

    override func awakeFromNib() {
        super.awakeFromNib()
        MainActor.assumeIsolated { configure() }
    }

    func apply(_ configuration: Configuration) {
        contentStackView.backgroundColor = configuration.backgroundColor

        textView.text = configuration.text
        textView.font = configuration.font
        textView.textColor = configuration.textColor

        placeholderTextView.text = configuration.placeholderText
        placeholderTextView.font = configuration.placeholderFont
        placeholderTextView.textColor = configuration.placeholderTextColor

        updatePlaceholder()
    }
}

extension JournalEntryTextCell: UITextViewDelegate {

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        delegate?.textView(textView, shouldChangeTextIn: range, replacementText: text, itemIdentifierType: itemIdentifierType) ?? true
    }

    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(textView, itemIdentifierType: itemIdentifierType)
        updatePlaceholder()
    }
}

private extension JournalEntryTextCell {

    func configure() {
        configureTextView()
        configurePlaceholderTextView()
    }

    func configureTextView() {
        textView.delegate = self
        textView.textContainerInset = UIEdgeInsets(top: 5, left: .zero, bottom: 5, right: .zero)
        textView.textContainer.lineFragmentPadding = .zero
    }

    func configurePlaceholderTextView() {
        placeholderTextView.textContainerInset = textView.textContainerInset
        placeholderTextView.textContainer.lineFragmentPadding = textView.textContainer.lineFragmentPadding
    }

    func updatePlaceholder() {
        placeholderTextView.isHidden = !textView.text.isEmpty
    }
}
