//
//  Coordinator.swift
//  Navigation
//
//  Created by Dmytro Yantsybaiev on 03.03.2025.
//

import UIKit

public protocol Coordinator: AnyObject, DefaultRoutes {

    var navigationController: UINavigationController { get }
    var parentCoordinator: (any Coordinator)? { get }
    var childCoordinators: [any Coordinator] { get set }

    func start()
}
