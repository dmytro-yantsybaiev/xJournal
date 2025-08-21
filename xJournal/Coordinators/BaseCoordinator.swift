//
//  BaseCoordinator.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit

class BaseCoordinator: Coordinator {

    let navigationController: UINavigationController
    var childCoordinators = [any Coordinator]()
    weak var parentCoordinator: (any Coordinator)?

    init(_ navigationController: UINavigationController, parent coordinator: (any Coordinator)? = nil) {
        self.parentCoordinator = coordinator
        self.navigationController = navigationController
    }
}
