//
//  JournalEntriesController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

@MainActor
protocol JournalEntriesControllerDelegate: AnyObject {

    func didTapAddEntry()
}

@MainActor
final class JournalEntriesController: NSObject {
    
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var addEntryButton: UIButton!
    @IBOutlet private(set) weak var footerView: UIVisualEffectView!
    @IBOutlet private(set) weak var dataSource: JournalEntriesDataSource!

    weak var delegate: JournalEntriesControllerDelegate?

    func configure() {
        configureAddEntryButton()
        configureFooterView()
        configureDataSource()
    }
}

private extension JournalEntriesController {

    func configureAddEntryButton() {
        let imageConfiguration = UIImage.SymbolConfiguration(pointSize: 25)
        let image = UIImage(systemName: "plus", withConfiguration: imageConfiguration)
        addEntryButton.setImage(image, for: .normal)
        addEntryButton.layer.cornerRadius = addEntryButton.bounds.width / 2
        addEntryButton.layer.shadowOffset = CGSize(width: 0, height: 5)
        addEntryButton.layer.shadowColor = UIColor.black.cgColor
        addEntryButton.layer.shadowRadius = 8
        addEntryButton.layer.shadowOpacity = 0.4
        addEntryButton.layer.shadowPath = UIBezierPath(ovalIn: addEntryButton.bounds).cgPath
        addEntryButton.addAction(UIAction { [unowned self] _ in delegate?.didTapAddEntry() }, for: .touchUpInside)
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
        footerView.isUserInteractionEnabled = false
    }

    func configureDataSource() {
        dataSource.configure(tableView, footerHeight: footerView.bounds.height)
    }
}
