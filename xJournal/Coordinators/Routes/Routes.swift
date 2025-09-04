//
//  Routes.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 27.08.2025.
//

extension Router {

    protocol JournalEntryEditorRoute: Route {
        func showJournalEntryEditor(journalEntry: JournalEntry?, completion: @escaping (JournalEntry?) -> Void)
    }
}
