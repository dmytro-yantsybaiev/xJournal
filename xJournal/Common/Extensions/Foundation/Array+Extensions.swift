//
//  Array+Extensions.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

import UIKit

extension Array {

    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

extension Array where Element: MenuIdentifiable {

    @MainActor
    func item(for configuration: UIContextMenuConfiguration) -> Element? {
        first { $0.menuID == configuration.identifier as? NSString }
    }

    @MainActor
    func index(for configuration: UIContextMenuConfiguration) -> Index? {
        firstIndex { $0.menuID == configuration.identifier as? NSString }
    }
}
