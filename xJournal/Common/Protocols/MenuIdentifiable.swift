//
//  MenuIdentifiable.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 06.09.2025.
//

import UIKit

protocol MenuIdentifiable {

    var id: String { get }
    var menuID: NSString { get }
}

extension MenuIdentifiable {

    var menuID: NSString {
        NSString(string: id)
    }
}
