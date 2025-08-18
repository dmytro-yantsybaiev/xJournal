//
//  DefaultRoutes.swift
//  Navigation
//
//  Created by Dmytro Yantsybaiev on 03.03.2025.
//

import UIKit

public typealias DefaultRoutes = (
    Router.FinishFlowRoute &
    Router.ResetFlowRoute &
    Router.SetRootRoute &
    Router.PushRoute &
    Router.PresentRoute &
    Router.PopRoute &
    Router.DismissRoute &
    Router.ReplaceTopRoute
)

extension Router {

    public protocol FinishFlowRoute: Route {
        func finishFlow()
        func finishFlow(completion: (() -> Void)?)
    }

    public protocol ResetFlowRoute: Route {
        func resetFlow()
    }

    public protocol SetRootRoute: Route {
        func set(root viewController: UIViewController, animated: Bool)
        func set(root viewController: UIViewController, animated: Bool, isNavigationBarHidden: Bool)
        func set(root viewControllers: [UIViewController], animated: Bool)
        func set(root viewControllers: [UIViewController], animated: Bool, isNavigationBarHidden: Bool)
    }

    public protocol PushRoute: Route {
        func push(_ viewController: UIViewController, animated: Bool)
        func push(_ viewController: UIViewController, animated: Bool, hidesBottomBarWhenPushed: Bool)
    }

    public protocol PresentRoute: Route {
        func present(_ viewController: UIViewController, animated: Bool)
        func present(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    }

    public protocol PopRoute: Route {
        @discardableResult func pop(animated: Bool) -> UIViewController?
        @discardableResult func pop(to viewController: UIViewController, animated: Bool) -> [UIViewController]?
        @discardableResult func popToRoot(animated: Bool) -> [UIViewController]?
    }

    public protocol DismissRoute: Route {
        func dismiss(animated: Bool)
        func dismiss(animated: Bool, completion: (() -> Void)?)
    }

    public protocol ReplaceTopRoute: Route {
        @discardableResult func replaceTop(with viewController: UIViewController, animated: Bool) -> UIViewController
        @discardableResult func replaceTop(with viewController: UIViewController, animated: Bool, isNavigationBarHidden: Bool) -> UIViewController
    }
}
