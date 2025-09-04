//
//  Optional+Extensions.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 03.09.2025.
//

extension Optional where Wrapped == String {

    var orEmpty: String {
        return self ?? ""
    }
}
