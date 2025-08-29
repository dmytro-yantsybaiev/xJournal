//
//  JournalEntry.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 21.08.2025.
//

import Foundation
import SwiftData

@Model
class JournalEntry {

    private(set) var id = UUID().uuidString
    private(set) var title: String?
    private(set) var text: String?

    init(title: String?, text: String?) {
        self.title = title
        self.text = text
    }
}
