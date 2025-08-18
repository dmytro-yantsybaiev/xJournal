//
//  Coordinator+Routes.swift
//  Navigation
//
//  Created by Dmytro Yantsybaiev on 03.03.2025.
//

import UIKit

public extension Coordinator {

    // MARK: - SetRootRoute

    func set(root viewController: UIViewController, animated: Bool) {
        set(root: viewController, animated: animated, isNavigationBarHidden: false)
    }

    func set(root viewController: UIViewController, animated: Bool, isNavigationBarHidden: Bool) {
        navigationController.setViewControllers([viewController], animated: animated)
        navigationController.isNavigationBarHidden = isNavigationBarHidden
    }

    func set(root viewControllers: [UIViewController], animated: Bool) {
        set(root: viewControllers, animated: animated, isNavigationBarHidden: false)
    }

    func set(root viewControllers: [UIViewController], animated: Bool, isNavigationBarHidden: Bool) {
        navigationController.setViewControllers(viewControllers, animated: animated)
        navigationController.isNavigationBarHidden = isNavigationBarHidden
    }

    // MARK: - PushRoute

    func push(_ viewController: UIViewController, animated: Bool) {
        push(viewController, animated: animated, hidesBottomBarWhenPushed: false)
    }

    func push(_ viewController: UIViewController, animated: Bool, hidesBottomBarWhenPushed: Bool) {
        viewController.hidesBottomBarWhenPushed = hidesBottomBarWhenPushed
        navigationController.pushViewController(viewController, animated: animated)
    }

    // MARK: - PresentRoute

    func present(_ viewController: UIViewController, animated: Bool) {
        present(viewController, animated: animated, completion: nil)
    }

    func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        navigationController.present(viewController, animated: animated, completion: completion)
    }

    // MARK: - PopRoute

    @discardableResult func pop(animated: Bool) -> UIViewController? {
        navigationController.popViewController(animated: animated)
    }

    @discardableResult func pop(to viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        navigationController.popToViewController(viewController, animated: animated)
    }

    @discardableResult func popToRoot(animated: Bool) -> [UIViewController]? {
        navigationController.popToRootViewController(animated: animated)
    }

    // MARK: - DismissRoute

    func dismiss(animated: Bool) {
        dismiss(animated: animated, completion: nil)
    }

    func dismiss(animated: Bool, completion: (() -> Void)?) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    // MARK: - ReplaceTopRoute

    @discardableResult func replaceTop(with viewController: UIViewController, animated: Bool) -> UIViewController {
        replaceTop(with: viewController, animated: animated, isNavigationBarHidden: false)
    }

    @discardableResult func replaceTop(with viewController: UIViewController, animated: Bool, isNavigationBarHidden: Bool) -> UIViewController {
        var viewControllers = navigationController.viewControllers
        let replacedViewController = viewControllers.removeLast()
        viewControllers.append(viewController)
        navigationController.setViewControllers(viewControllers, animated: animated)
        navigationController.isNavigationBarHidden = isNavigationBarHidden
        return replacedViewController
    }
}
