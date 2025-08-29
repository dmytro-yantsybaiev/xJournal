//
//  Routes.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 27.08.2025.
//

extension Router {

    protocol CreateJournalEntryRoute: Route {
        func showCreateJournalEntry(completion: @escaping (JournalEntry) -> Void)
    }
}
