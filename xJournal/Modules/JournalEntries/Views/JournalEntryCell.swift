//
//  JournalEntryCell.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 21.08.2025.
//

import UIKit

final class JournalEntryCell: UITableViewCell {

    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configure()
    }
}

private extension JournalEntryCell {

    func configure() {
        contentStackView.layer.cornerRadius = 10
        contentStackView.layer.shadowOffset = .zero
        contentStackView.layer.shadowColor = UIColor.lightGray.cgColor
        contentStackView.layer.shadowRadius = 4
        contentStackView.layer.shadowOpacity = 0.75
    }
}
