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
        let didTapAddEndtryButtonPublisher: AnyPublisher<Void, Never>
        let didBookmarkEntryPublisher: AnyPublisher<(UITableView, JournalEntry, IndexPath), Never>
    }

    struct Output {
        let journalEntriesPublisher: AnyPublisher<[JournalEntry], Never>
    }

    weak var coordinator: (
        Router.CreateJournalEntryRoute
    )?

    private var container: ModelContainer?

    private let journalEntriesPassthroughSubject = PassthroughSubject<[JournalEntry], Never>()
    private var cancellables = Set<AnyCancellable>()

    init() {
        container = try? ModelContainer(for: JournalEntry.self)
    }

    func transform(_ input: Input) -> Output {
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
            .didTapAddEndtryButtonPublisher
            .subscribe(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                showCreateJournalEntry()
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

    private func showCreateJournalEntry() {
        coordinator?.showCreateJournalEntry { [unowned container] newEntry in
            container?.mainContext.insert(newEntry)
        }
    }
}
