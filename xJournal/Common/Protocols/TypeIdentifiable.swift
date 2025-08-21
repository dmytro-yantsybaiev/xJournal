//
//  TypeIdentifiable.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

protocol TypeIdentifiable: UIView {

    static var nibName: String { get }
    static var nib: UINib { get }

    static func instantiateNib() -> Self
}

extension TypeIdentifiable {

    static var nibName: String {
        String(describing: self)
    }

    static var nib: UINib {
        UINib(nibName: nibName, bundle: nil)
    }

    static func instantiateNib() -> Self {
        let nib = UINib(nibName: nibName, bundle: Bundle(for: Self.self)).instantiate(withOwner: Self.self, options: nil).first

        guard let nib = nib as? Self else {
            fatalError("Unable to load nib \(nibName)")
        }

        return nib
    }
}
