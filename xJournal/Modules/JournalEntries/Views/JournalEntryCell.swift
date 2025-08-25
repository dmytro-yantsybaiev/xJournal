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
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var textView: UITextView!
    @IBOutlet private weak var chevronImageViewContainer: UIView!
    @IBOutlet private weak var chevronImageView: UIImageView!
    @IBOutlet private weak var textViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomSeparatorHeightConstraint: NSLayoutConstraint!

    weak var delegate: JournalEntryCellDelegate?

    var textViewEstimatedHeight: CGFloat {
        textView.sizeThatFits(CGSize(width: textView.bounds.width, height: .greatestFiniteMagnitude)).height
    }

    var textViewMinimumHeight: CGFloat {
        textViewEstimatedHeight < 120 ? textViewEstimatedHeight : 120
    }

    var isExpandable: Bool {
        textViewEstimatedHeight > textViewMinimumHeight
    }

    var isExpanded: Bool {
        textViewHeightConstraint.constant > textViewMinimumHeight
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        MainActor.assumeIsolated { configure() }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
        textViewHeightConstraint.constant = textViewMinimumHeight
        chevronImageViewContainer.isHidden = !isExpandable
    }

    func render(title text: String?) {
        titleLabel.text = text
    }

    func render(text: String?) {
        textView.text = text
        textViewHeightConstraint.constant = textViewMinimumHeight
        chevronImageViewContainer.isHidden = !isExpandable
    }

    func updateTextView(height: CGFloat) {
        textViewHeightConstraint.constant = height
    }

    func updateBottomSeparator(height: CGFloat) {
        bottomSeparatorHeightConstraint.constant = height
    }

    func toggleExpandedState() {
        guard isExpandable else {
            return
        }

        if isExpanded {
            updateTextView(height: textViewMinimumHeight)
            chevronImageViewContainer.isHidden = !isExpandable
        } else {
            updateTextView(height: textViewEstimatedHeight)
            chevronImageViewContainer.isHidden = true
        }
    }
}

private extension JournalEntryCell {

    func configure() {
        configureContentStackView()
        configureTextTextView()
        configureChevronImageView()
    }

    func configureContentStackView() {
        contentStackView.layer.cornerRadius = 10
        contentStackView.layer.shadowOffset = .zero
        contentStackView.layer.shadowRadius = 5
        contentStackView.layer.shadowOpacity = 0.1
        contentStackView.layer.shadowColor = UIColor.black.cgColor
        contentStackView.layer.shouldRasterize = true
        contentStackView.layer.rasterizationScale = UIScreen.main.scale

    }

    func configureTextTextView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onTapTextView))
        textView.addGestureRecognizer(tapGesture)
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = .zero
    }

    func configureChevronImageView() {
        let blurLayer = CAGradientLayer()
        blurLayer.frame = chevronImageViewContainer.bounds
        blurLayer.shadowRadius = 4
        blurLayer.shadowPath = CGPath(roundedRect: chevronImageViewContainer.bounds.insetBy(dx: -2, dy: 0), cornerWidth: 0, cornerHeight: 0, transform: nil)
        blurLayer.shadowOpacity = 1
        blurLayer.shadowOffset = .zero
        blurLayer.shadowColor = UIColor.white.cgColor
        chevronImageView.backgroundColor = contentStackView.backgroundColor
        chevronImageViewContainer.backgroundColor = contentStackView.backgroundColor
        chevronImageViewContainer.layer.mask = blurLayer
        chevronImageViewContainer.isHidden = true
    }

    @objc func onTapTextView() {
        delegate?.didTapTextView(cell: self)
    }
}
