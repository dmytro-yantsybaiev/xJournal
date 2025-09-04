//
//  JournalEntriesHeaderView.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 23.08.2025.
//

import UIKit

class JournalEntriesHeaderView: UITableViewHeaderFooterView {

    @IBOutlet weak var spacingHeightConstraint: NSLayoutConstraint!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        spacingHeightConstraint.constant = 0
    }
}
