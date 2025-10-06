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
        let textDidChangePublisher: AnyPublisher<(JournalEntryEditorDataSource.Item, String), Never>
    }

    struct Output {
        let renderBookmarkButtonPublisher: AnyPublisher<Bool, Never>
        let renderHideShowTitleActionPublisher: AnyPublisher<Bool, Never>
        let becomeFirstResponderForItemPublisher: AnyPublisher<JournalEntryEditorDataSource.Item, Never>
        let appendItemsPublisher: AnyPublisher<[JournalEntryEditorDataSource.Item], Never>
        let insertItemPublisher: AnyPublisher<(JournalEntryEditorDataSource.Item, JournalEntryEditorDataSource.Item), Never>
        let deleteItemPublisher: AnyPublisher<JournalEntryEditorDataSource.Item, Never>
    }

    weak var coordinator: Router.DismissRoute?

    let journalEntry: JournalEntry

    private(set) var itemText = [JournalEntryEditorDataSource.Item: String]()

    private let renderBookmarkButtonPassthroughSubject = PassthroughSubject<Bool, Never>()
    private let renderHideShowTitleActionPassthroughSubject = PassthroughSubject<Bool, Never>()
    private let becomeFirstResponderForItemPassthroughSubject = PassthroughSubject<JournalEntryEditorDataSource.Item, Never>()
    private let appendItemsToTextSectionPassthroughSubject = PassthroughSubject<[JournalEntryEditorDataSource.Item], Never>()
    private let insertItemPassthroughSubject = PassthroughSubject<(JournalEntryEditorDataSource.Item, JournalEntryEditorDataSource.Item), Never>()
    private let deleteItemPassthroughSubject = PassthroughSubject<JournalEntryEditorDataSource.Item, Never>()
    private let completion: (JournalEntry?) -> Void
    private var cancellables = Set<AnyCancellable>()

    init(journalEntry: JournalEntry?, completion: @escaping (JournalEntry?) -> Void) {
        self.journalEntry = journalEntry ?? JournalEntry()
        self.completion = completion
        itemText[.title] = journalEntry?.title
        itemText[.body] = journalEntry?.body
    }

    func bind(_ input: Input) -> Output {
        input
            .viewDidLoadPublisher
            .receive(on: DispatchQueue.main)
            .map { _ in [
                JournalEntryEditorDataSource.Item.title,
                JournalEntryEditorDataSource.Item.body,
            ] }
            .sink { [unowned self] items in appendItemsToTextSectionPassthroughSubject.send(items) }
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
            .viewDidLoadPublisher
            .receive(on: DispatchQueue.main)
            .sink { [unowned self] _ in
                if journalEntry.title?.isEmpty ?? true, journalEntry.body?.isEmpty ?? true {
                    becomeFirstResponderForItemPassthroughSubject.send(.title)
                } else {
                    becomeFirstResponderForItemPassthroughSubject.send(.body)
                }
            }
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
                    deleteItemPassthroughSubject.send(.title)
                } else {
                    insertItemPassthroughSubject.send((.title, .body))
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
            .sink { [unowned self] item, text in itemText[item] = text }
            .store(in: &cancellables)

        return Output(
            renderBookmarkButtonPublisher: renderBookmarkButtonPassthroughSubject.eraseToAnyPublisher(),
            renderHideShowTitleActionPublisher: renderHideShowTitleActionPassthroughSubject.eraseToAnyPublisher(),
            becomeFirstResponderForItemPublisher: becomeFirstResponderForItemPassthroughSubject.eraseToAnyPublisher(),
            appendItemsPublisher: appendItemsToTextSectionPassthroughSubject.eraseToAnyPublisher(),
            insertItemPublisher: insertItemPassthroughSubject.eraseToAnyPublisher(),
            deleteItemPublisher: deleteItemPassthroughSubject.eraseToAnyPublisher(),
        )
    }
}

private extension JournalEntryEditorViewModel {

    func saveJournalEntry() {
        journalEntry.update(title: itemText[.title])
        journalEntry.update(body: itemText[.body])

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
