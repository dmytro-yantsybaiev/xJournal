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
        Router.JournalEntryEditorRoute &
        Router.DismissRoute
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
            .sink { [unowned self] journalEntry in
                showJournalEntryEditor(journalEntry)
            }
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
        let descriptor = FetchDescriptor<JournalEntry>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        let journalEntries = (try? container?.mainContext.fetch(descriptor)) ?? []
        renderEntriesPassthroughSubject.send(journalEntries)
    }

    

    func showJournalEntryEditor(_ journalEntry: JournalEntry? = nil) {
        coordinator?.showJournalEntryEditor(journalEntry: journalEntry) { [unowned self] newJournalEntry in
            defer {
                try? container?.mainContext.save()
            }

            if let newJournalEntry {
                container?.mainContext.insert(newJournalEntry)
                insertEntryPassthroughSubject.send(newJournalEntry)
            }

            if let journalEntry, newJournalEntry == nil {
                container?.mainContext.delete(journalEntry)
                deleteEntryPassthroughSubject.send(journalEntry)
            }
        }
    }
}
