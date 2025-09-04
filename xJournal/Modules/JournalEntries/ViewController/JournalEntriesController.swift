//
//  JournalEntriesController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

@MainActor
protocol JournalEntriesControllerDelegate: AnyObject {

    func didTapSearchButton()
    func didTapMenuButton()
    func didTapEdit(_ journalEntry: JournalEntry)
    func didTapAddEntry()
}

@MainActor
final class JournalEntriesController: NSObject {

    @IBOutlet private(set) weak var dataSource: JournalEntriesDataSource!
    @IBOutlet private(set) weak var tableView: UITableView!
    @IBOutlet private(set) weak var addEntryButton: UIButton!
    @IBOutlet private(set) weak var footerView: UIVisualEffectView!

    private(set) lazy var navigationBarTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Journal"
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        return label
    }()

    private(set) lazy var searchButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = button.frame.width / 2
        button.addAction(UIAction { [unowned self] _ in delegate?.didTapSearchButton() }, for: .touchUpInside)
        return button
    }()

    private(set) lazy var menuButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = button.frame.width / 2
        button.addAction(UIAction { [unowned self] _ in delegate?.didTapMenuButton() }, for: .touchUpInside)
        return button
    }()

    weak var delegate: JournalEntriesControllerDelegate?

    func configure() {
        configureDataSource()
        configureAddEntryButton()
        configureFooterView()
    }
}

private extension JournalEntriesController {

    func configureDataSource() {
        dataSource.configure(tableView, footerHeight: footerView.bounds.height)

        dataSource.didTapEdit = { [unowned self] journalEntry in
            delegate?.didTapEdit(journalEntry)
        }
    }

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
}
