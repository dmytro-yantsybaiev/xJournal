//
//  AppCoordinator.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit

final class AppCoordinator: BaseCoordinator {

    private let window: UIWindow?

    init(_ window: UIWindow?) {
        self.window = window
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        super.init(navigationController)
    }

    override func start() {
        super.start()
        set(root: ViewController.storyboard, animated: true)
    }
}
