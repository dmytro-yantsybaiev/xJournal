//
//  JournalEntry.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 21.08.2025.
//

import Foundation

struct JournalEntry: Hashable {
    let id = UUID().uuidString
    let title: String?
    let text: String?
}
