//
//  Array+Extensions.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 19.08.2025.
//

extension Array {

    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
