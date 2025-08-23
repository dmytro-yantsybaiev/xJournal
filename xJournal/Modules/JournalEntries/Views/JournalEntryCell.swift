//
//  JournalEntryCell.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 21.08.2025.
//

import UIKit

@MainActor
protocol JournalEntryCellDelegate: AnyObject {

    func didTapTextView(cell: JournalEntryCell)
}

final class JournalEntryCell: UITableViewCell {

    @IBOutlet private(set) weak var contentStackView: UIStackView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var textView: UITextView!

    @IBOutlet private(set) weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private(set) weak var bottomSeparatorHeightConstraint: NSLayoutConstraint!

    weak var delegate: JournalEntryCellDelegate?

    let textViewMinimumHeight: CGFloat = 300

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
        textViewHeightConstraint.constant = textViewMinimumHeight
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
        textView.addGestureRecognizer(tapGesture)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
    }

    @objc func onTapTextView() {
        delegate?.didTapTextView(cell: self)
    }
}
