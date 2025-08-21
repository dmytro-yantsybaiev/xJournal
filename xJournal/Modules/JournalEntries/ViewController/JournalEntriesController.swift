//
//  JournalEntriesController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

final class JournalEntriesController: NSObject {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var addEntryButton: UIButton!
    @IBOutlet private weak var footerView: UIVisualEffectView!
    @IBOutlet private weak var dataSource: JournalEntriesDataSource!

    func configure() {
        dataSource.configure(tableView, footerHeight: footerView.bounds.height)
        configureAddEntryButton()
        configureFooterView()
    }
}

private extension JournalEntriesController {

    func configureAddEntryButton() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfiguration)
        addEntryButton.setImage(image, for: .normal)
        addEntryButton.layer.cornerRadius = addEntryButton.bounds.width / 2
        addEntryButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        addEntryButton.layer.shadowColor = UIColor.lightGray.cgColor
        addEntryButton.layer.shadowRadius = 8
        addEntryButton.layer.shadowOpacity = 0.75
    }

    func configureFooterView() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = footerView.bounds
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor,
        ]
        gradientLayer.locations = [0.0, 1.0]
        footerView.layer.mask = gradientLayer
    }
}
