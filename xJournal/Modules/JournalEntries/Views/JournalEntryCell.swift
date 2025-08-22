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
    @IBOutlet private(set) weak var separatorView: UIView!

    @IBOutlet private(set) weak var spacingHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var separatorViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) var textTextViewHeightConstraint: NSLayoutConstraint!

    weak var delegate: UITableViewCellDelegate?

    var isExpanded = false

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
        spacingHeightConstraint.constant = 0
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
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapTextView))
        textTextView.addGestureRecognizer(tapGesture)
        textTextView.textContainerInset = .zero
        textTextView.textContainer.lineFragmentPadding = .zero
    }

    @objc func onTapTextView() {
        isExpanded.toggle()
        textTextViewHeightConstraint.isActive = !isExpanded
        delegate?.contentDidChange(cell: self)
    }
}
