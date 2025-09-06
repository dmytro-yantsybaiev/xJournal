//
//  JournalEntryEditorViewModel.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 27.08.2025.
//

import Foundation
import Combine

final class JournalEntryEditorViewModel: ViewModel {

    struct Input {
        let viewDidLoadPublisher: AnyPublisher<Void, Never>
        let didTapBookmarkPublisher: AnyPublisher<Void, Never>
        let didTapHideShowTitlePublisher: AnyPublisher<Void, Never>
        let didTapDeletePublisher: AnyPublisher<Void, Never>
        let didTapDonePublisher: AnyPublisher<Void, Never>
        let textDidChangePublisher: AnyPublisher<(JournalEntryEditorDataSource.Entry, String), Never>
    }

    struct Output {
        let renderBookmarkButtonPublisher: AnyPublisher<Bool, Never>
        let renderHideShowTitleActionPublisher: AnyPublisher<Bool, Never>
        let appendEntriesPublisher: AnyPublisher<[JournalEntryEditorDataSource.Entry], Never>
        let insertEntryPublisher: AnyPublisher<(JournalEntryEditorDataSource.Entry, JournalEntryEditorDataSource.Entry), Never>
        let deleteEntryPublisher: AnyPublisher<JournalEntryEditorDataSource.Entry, Never>
    }

    weak var coordinator: Router.DismissRoute?

    let journalEntry: JournalEntry

    private(set) var entryText = [JournalEntryEditorDataSource.Entry: String]()

    private let renderBookmarkButtonPassthroughSubject = PassthroughSubject<Bool, Never>()
    private let renderHideShowTitleActionPassthroughSubject = PassthroughSubject<Bool, Never>()
    private let appendEntriesToTextSectionPassthroughSubject = PassthroughSubject<[JournalEntryEditorDataSource.Entry], Never>()
    private let insertEntryPassthroughSubject = PassthroughSubject<(JournalEntryEditorDataSource.Entry, JournalEntryEditorDataSource.Entry), Never>()
    private let deleteEntryPassthroughSubject = PassthroughSubject<JournalEntryEditorDataSource.Entry, Never>()
    private let completion: (JournalEntry?) -> Void
    private var cancellables = Set<AnyCancellable>()

    init(journalEntry: JournalEntry?, completion: @escaping (JournalEntry?) -> Void) {
        self.journalEntry = journalEntry ?? JournalEntry()
        self.completion = completion
        entryText[.title] = journalEntry?.title
        entryText[.body] = journalEntry?.body
    }

    func bind(_ input: Input) -> Output {
        input
            .viewDidLoadPublisher
            .receive(on: DispatchQueue.main)
            .map { _ in [
                JournalEntryEditorDataSource.Entry.title,
                JournalEntryEditorDataSource.Entry.body,
            ] }
            .sink { [unowned self] entris in appendEntriesToTextSectionPassthroughSubject.send(entris) }
            .store(in: &cancellables)

        input
            .viewDidLoadPublisher
            .receive(on: DispatchQueue.main)
            .map { [unowned self] _ in journalEntry.isBookmarked }
            .sink { [unowned self] isBookmarked in renderBookmarkButtonPassthroughSubject.send(isBookmarked) }
            .store(in: &cancellables)

        input
            .viewDidLoadPublisher
            .receive(on: DispatchQueue.main)
            .map { [unowned self] _ in journalEntry.isTitleHidden }
            .sink { [unowned self] isTitleHidden in renderHideShowTitleActionPassthroughSubject.send(isTitleHidden) }
            .store(in: &cancellables)

        input
            .didTapBookmarkPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                journalEntry.update(isBookmarked: !journalEntry.isBookmarked)
                renderBookmarkButtonPassthroughSubject.send(journalEntry.isBookmarked)
            }
            .store(in: &cancellables)

        input
            .didTapHideShowTitlePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                journalEntry.update(isTitleHidden: !journalEntry.isTitleHidden)
                renderHideShowTitleActionPassthroughSubject.send(journalEntry.isTitleHidden)
                if journalEntry.isTitleHidden {
                    deleteEntryPassthroughSubject.send(.title)
                } else {
                    insertEntryPassthroughSubject.send((.title, .body))
                }
            }
            .store(in: &cancellables)

        input
            .didTapDeletePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in deleteJournalEntry() }
            .store(in: &cancellables)

        input
            .didTapDonePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in saveJournalEntry() }
            .store(in: &cancellables)

        input
            .textDidChangePublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] entry, text in entryText[entry] = text }
            .store(in: &cancellables)

        return Output(
            renderBookmarkButtonPublisher: renderBookmarkButtonPassthroughSubject.eraseToAnyPublisher(),
            renderHideShowTitleActionPublisher: renderHideShowTitleActionPassthroughSubject.eraseToAnyPublisher(),
            appendEntriesPublisher: appendEntriesToTextSectionPassthroughSubject.eraseToAnyPublisher(),
            insertEntryPublisher: insertEntryPassthroughSubject.eraseToAnyPublisher(),
            deleteEntryPublisher: deleteEntryPassthroughSubject.eraseToAnyPublisher(),
        )
    }
}

private extension JournalEntryEditorViewModel {

    func saveJournalEntry() {
        journalEntry.update(title: entryText[.title])
        journalEntry.update(body: entryText[.body])

        if !journalEntry.title.orEmpty.isEmpty, !journalEntry.isTitleHidden {
            completion(journalEntry)
            coordinator?.dismiss(animated: true)
        }

        if !journalEntry.body.orEmpty.isEmpty {
            completion(journalEntry)
            coordinator?.dismiss(animated: true)
        }

        coordinator?.dismiss(animated: true)
    }

    func deleteJournalEntry() {
        coordinator?.dismiss(animated: true) { [unowned self] in completion(nil) }
    }
}
