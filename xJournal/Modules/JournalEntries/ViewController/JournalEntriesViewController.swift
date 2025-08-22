//
//  JournalEntriesViewController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit
import Combine

final class JournalEntriesViewController: BaseViewController {

    @IBOutlet private weak var controller: JournalEntriesController!

    private lazy var searchButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = button.frame.width / 2
        button.addAction(
            UIAction { [unowned self] _ in didTapSearchButtonPassthroughSubject.send() },
            for: .touchUpInside
        )
        return button
    }()

    private lazy var menuButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = button.frame.width / 2
        button.addAction(
            UIAction { [unowned self] _ in didTapMenuButtonPassthroughSubject.send() },
            for: .touchUpInside
        )
        return button
    }()

    var observer: NSKeyValueObservation?

    var viewModel: JournalEntriesViewModel!

    private let didTapSearchButtonPassthroughSubject = PassthroughSubject<Void, Never>()
    private let didTapMenuButtonPassthroughSubject = PassthroughSubject<Void, Never>()

    override func viewDidLoad() {
        super.viewDidLoad()
        sendViewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        controller.footerView.layer.mask?.frame = controller.footerView.bounds
    }

    override func configure() {
        super.configure()
        controller.configure()
        controller.delegate = self
        configureNavigationBar()
    }

    override func bind() {
        super.bind()

        let input = JournalEntriesViewModel.Input(
            viewDidLoadPublisher: viewDidLoadPassthroughSubject.eraseToAnyPublisher(),
            didTapSearchButtonPublisher: didTapSearchButtonPassthroughSubject.eraseToAnyPublisher(),
            didTapMenuButtonPublisher: didTapMenuButtonPassthroughSubject.eraseToAnyPublisher(),
        )
        let output = viewModel.transform(input)

        output
            .journalEntriesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] journalEntries in
                controller.dataSource.render(entries: journalEntries)
            }
            .store(in: &cancellables)

        observer = navigationController?.navigationBar.observe(
            \.frame,
             options: [.new]
        ) { [unowned self] _, changes in
            MainActor.assumeIsolated {
                if let height = changes.newValue?.height {
                    if height > 44.0 {
                        searchButton.tintColor = .label
                        searchButton.backgroundColor = .systemGray5
                    } else {
                        searchButton.tintColor = .clear
                        searchButton.backgroundColor = .clear

                    }
                }
            }
        }

    }
}

extension JournalEntriesViewController: JournalEntriesControllerDelegate {

    func didTapAddEntry() {
        let viewController = UIViewController()
        viewController.view.backgroundColor = .purple
        navigationController?.pushViewController(viewController, animated: true)
    }
}

private extension JournalEntriesViewController {

    func configureNavigationBar() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: menuButton),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(customView: searchButton),
        ]
        navigationItem.largeTitleDisplayMode = .always

//        navigationBar.
//        navigationBar.addSubview(searchButton)
//
//        searchButton.translatesAutoresizingMaskIntoConstraints = false
//
//        NSLayoutConstraint.activate([
//            searchButton.trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor, constant: -20),
//            searchButton.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -12),
//            searchButton.widthAnchor.constraint(equalToConstant: 30),
//            searchButton.heightAnchor.constraint(equalToConstant: 30)
//        ])

    }
}

#Preview {
    let navigationController = UINavigationController()
    let viewController = JournalEntriesViewController.storyboard
    let viewModel = JournalEntriesViewModel()
    navigationController.setViewControllers([viewController], animated: false)
    navigationController.navigationBar.prefersLargeTitles = true
    viewController.viewModel = viewModel
    viewController.title = "Journal"
    return navigationController
}
