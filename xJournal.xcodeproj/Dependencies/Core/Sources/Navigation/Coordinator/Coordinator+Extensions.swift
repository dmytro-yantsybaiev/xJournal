//
//  Coordinator+Extensions.swift
//  Navigation
//
//  Created by Dmytro Yantsybaiev on 03.03.2025.
//

public extension Coordinator {

    func append(child coordinator: any Coordinator) {
        childCoordinators.append(coordinator)
    }

    @discardableResult
    func remove(child coordinator: any Coordinator) -> Coordinator? {
        guard let index = childCoordinators.firstIndex(where: { $0 === coordinator }) else {
            return nil
        }

        return childCoordinators.remove(at: index)
    }

    func removeAllChildCoordinators() {
        childCoordinators.removeAll()
    }

    func find<T: Coordinator>(first: T.Type) -> T? {
        childCoordinators.first { $0 is T } as? T
    }

    func find<T: Coordinator>(last: T.Type) -> T? {
        childCoordinators.last { $0 is T } as? T
    }
}
