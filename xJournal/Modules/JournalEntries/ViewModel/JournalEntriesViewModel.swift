//
//  JournalEntriesViewModel.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit
import Combine
import SwiftData

@MainActor
final class JournalEntriesViewModel: ViewModel {

    struct Input {
        let viewDidLoadPublisher: AnyPublisher<Void, Never>
        let didTapSearchButtonPublisher: AnyPublisher<Void, Never>
        let didTapMenuButtonPublisher: AnyPublisher<Void, Never>
        let didTapBookmarkEntryPublisher: AnyPublisher<(UITableView, JournalEntry, IndexPath), Never>
        let didTapEditEntryPublisher: AnyPublisher<JournalEntry, Never>
        let didTapAddEndtryButtonPublisher: AnyPublisher<Void, Never>
    }

    struct Output {
        let renderEntriesPublisher: AnyPublisher<[JournalEntry], Never>
        let insertEntryPublisher: AnyPublisher<JournalEntry, Never>
        let deleteEntryPublisher: AnyPublisher<JournalEntry, Never>
    }

    weak var coordinator: (
        Router.JournalEntryEditorRoute
    )?

    private var container: ModelContainer?

    private let renderEntriesPassthroughSubject = PassthroughSubject<[JournalEntry], Never>()
    private let insertEntryPassthroughSubject = PassthroughSubject<JournalEntry, Never>()
    private let deleteEntryPassthroughSubject = PassthroughSubject<JournalEntry, Never>()
    private var cancellables = Set<AnyCancellable>()

    init() {
        container = try? ModelContainer(for: JournalEntry.self)
    }

    func bind(_ input: Input) -> Output {
        input
            .viewDidLoadPublisher
            .sink { [unowned self] _ in
                loadJournalEntries()
            }
            .store(in: &cancellables)

        input
            .didTapSearchButtonPublisher
            .sink { _ in
                print("didTapSearch")
            }
            .store(in: &cancellables)

        input
            .didTapMenuButtonPublisher
            .sink { _ in
                print("didTapMenu")
            }
            .store(in: &cancellables)

        input
            .didTapEditEntryPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] journalEntry in showJournalEntryEditor(journalEntry) }
            .store(in: &cancellables)

        input
            .didTapAddEndtryButtonPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                showJournalEntryEditor()
            }
            .store(in: &cancellables)

        return Output(
            renderEntriesPublisher: renderEntriesPassthroughSubject.eraseToAnyPublisher(),
            insertEntryPublisher: insertEntryPassthroughSubject.eraseToAnyPublisher(),
            deleteEntryPublisher: deleteEntryPassthroughSubject.eraseToAnyPublisher(),
        )
    }
}

private extension JournalEntriesViewModel {

    func loadJournalEntries() {
        let descriptor = FetchDescriptor<JournalEntry>()
        let journalEntries = (try? container?.mainContext.fetch(descriptor)) ?? []
        renderEntriesPassthroughSubject.send(journalEntries)
    }

    private func showJournalEntryEditor(_ journalEntry: JournalEntry? = nil) {
        coordinator?.showJournalEntryEditor(journalEntry: journalEntry) { [unowned self] newEntry in
            if let newEntry {
                container?.mainContext.insert(newEntry)
                try? container?.mainContext.save()
                insertEntryPassthroughSubject.send(newEntry)
            }
            if let journalEntry, newEntry == nil {
                container?.mainContext.delete(journalEntry)
                try? container?.mainContext.save()
                deleteEntryPassthroughSubject.send(journalEntry)
            }
        }
    }
}
