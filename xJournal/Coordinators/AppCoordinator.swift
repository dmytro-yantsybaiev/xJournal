//
//  AppCoordinator.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit

final class AppCoordinator: BaseCoordinator, Router.StartFlowRoute {

    private let window: UIWindow?

    init(_ window: UIWindow?) {
        self.window = window
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        super.init(navigationController)
    }

    func start(completion: (() -> Void)?) {
        if let coordinator = find(first: JournalEntriesCoordinator.self) {
            remove(child: coordinator)
            return
        }
        let coordinator = JournalEntriesCoordinator(navigationController, parent: self)
        append(child: coordinator)
        coordinator.start()
        completion?()
    }
}
