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
        let didTapEditEntryPublisher: AnyPublisher<JournalEntry, Never>
        let didTapAddEndtryButtonPublisher: AnyPublisher<Void, Never>
        let didBookmarkEntryPublisher: AnyPublisher<(UITableView, JournalEntry, IndexPath), Never>
    }

    struct Output {
        let journalEntriesPublisher: AnyPublisher<[JournalEntry], Never>
    }

    weak var coordinator: (
        Router.JournalEntryEditorRoute
    )?

    private var container: ModelContainer?

    private let journalEntriesPassthroughSubject = PassthroughSubject<[JournalEntry], Never>()
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
            journalEntriesPublisher: journalEntriesPassthroughSubject.eraseToAnyPublisher()
        )
    }
}

private extension JournalEntriesViewModel {

    func loadJournalEntries() {
        let descriptor = FetchDescriptor<JournalEntry>()
        let journalEntries = (try? container?.mainContext.fetch(descriptor)) ?? []
        journalEntriesPassthroughSubject.send(journalEntries)
    }

    private func showJournalEntryEditor(_ journalEntry: JournalEntry? = nil) {
        coordinator?.showJournalEntryEditor(journalEntry: journalEntry) { [unowned self] newEntry in
            if let newEntry {
                container?.mainContext.insert(newEntry)
            }
            if let journalEntry, newEntry == nil {
                container?.mainContext.delete(journalEntry)
            }
            loadJournalEntries()
        }
    }
}
