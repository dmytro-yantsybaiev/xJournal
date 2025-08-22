//
//  JournalEntryCell.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 21.08.2025.
//

import UIKit

final class JournalEntryCell: UITableViewCell {

    @IBOutlet private(set) weak var contentStackView: UIStackView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var textTextView: UITextView!
    @IBOutlet private(set) var textTextViewHeightConstraint: NSLayoutConstraint!

    weak var delegate: UITableViewCellDelegate?

    private var isExpanded = false

    override func awakeFromNib() {
        super.awakeFromNib()
        MainActor.assumeIsolated { configure() }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentStackView.layer.shadowPath = UIBezierPath(roundedRect: contentStackView.bounds, cornerRadius: 10).cgPath
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        isExpanded = false
        textTextViewHeightConstraint.isActive = true
    }
}

extension JournalEntryCell: UITextViewDelegate {

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        isExpanded.toggle()
        textTextViewHeightConstraint.isActive = !isExpanded
        delegate?.contentDidChange(cell: self)
        return false
    }
}

private extension JournalEntryCell {

    func configure() {
        configureContentStackView()
        configureTextTextView()
    }

    func configureContentStackView() {
        contentStackView.layer.cornerRadius = 10
        contentStackView.layer.shadowOffset = .zero
        contentStackView.layer.shadowColor = UIColor.black.cgColor
        contentStackView.layer.shadowRadius = 6
        contentStackView.layer.shadowOpacity = 0.1
    }

    func configureTextTextView() {
        textTextView.delegate = self
        textTextView.textContainerInset = .zero
        textTextView.textContainer.lineFragmentPadding = .zero
    }
}
