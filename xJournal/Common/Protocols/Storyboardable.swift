//
//  Storyboardable.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit

protocol Storyboardable: UIViewController {

    static var storyboardName: String { get }
    static var storyboard: Self { get }
}

extension Storyboardable {

    static var storyboardName: String {
        String(describing: self)
    }

    static var storyboard: Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self))

        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Could not instantiate initial storyboard with name: \(storyboardName)")
        }

        return viewController
    }
}
