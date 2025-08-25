//
//  JournalEntriesViewModel.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import Combine

final class JournalEntriesViewModel: ViewModel {

    struct Input {
        let viewDidLoadPublisher: AnyPublisher<Void, Never>
        let didTapSearchButtonPublisher: AnyPublisher<Void, Never>
        let didTapMenuButtonPublisher: AnyPublisher<Void, Never>
    }

    struct Output {
        let journalEntriesPublisher: AnyPublisher<[JournalEntry], Never>
    }

    private let journalEntriesPassthroughSubject = PassthroughSubject<[JournalEntry], Never>()
    private var cancellables = Set<AnyCancellable>()

    func transform(_ input: Input) -> Output {
        input
            .viewDidLoadPublisher
            .sink { [unowned self] _ in
                let journalEntries = (0...100).map { index in JournalEntry(title: "Some Title\n\(index)", text: "the only way i could ever be able is to get my own car to work for a month or so before the pandemic hit so that my parents can have the money for the trip to my house or something and then go back home to do the rest the rest the next year or the rest the year and i could just be able afford the money to get a new one for the next few years so that way my mom could have the car and i can afford to pay the bills for my house but she doesn’t want me and she wants me and her and my mom and her and i have a job and i can get the only way i could ever be able is to get my own car to work for a month or so before the pandemic hit so that my parents can have the money for the trip to my house or something and then go back home to do the rest the rest the next year or the rest the year and i could just be able afford the money to get a new one for the next few years so that way my mom could have the car and i can afford to pay the bills for my house but she doesn’t want me and she wants me and her and my mom and her and i have a job and i can get the only way i could ever be able is to get my own car to work for a month or so before the pandemic hit so that my parents can have the money for the trip to my house or something and then go back home to do the rest the rest the next year or the rest the year and i could just be able afford the money to get a new one for the next few years so that way my mom could have the car and i can afford to pay the bills for my house but she doesn’t want me and she wants me and her and my mom and her and i have a job and i can get the only way i could ever be able is to get my own car to work for a month or so before the pandemic hit so that my parents can have the money for the trip to my house or something and then go back home to do the rest the rest the next year or the rest the year and i could just be able afford the money to get a new one for the next few years so that way my mom could have the car and i can afford to pay the bills for my house but she doesn’t want me and she wants me and her and my mom and her and i have a job and i can get the only way i could ever be able is to get my own car to work for a month or so before the pandemic hit so that my parents can have the money for the trip to my house or something and then go back home to do the rest the rest the next year or the rest the year and i could just be able afford the money to get a new one for the next few years so that way my mom could have the car and i can afford to pay the bills for my house but she doesn’t want me and she wants me and her and my mom and her and i have a job and i can get the only way i could ever be able is to get my own car to work for a month or so before the pandemic hit so that my parents can have the money for the trip to my house or something and then go back home to do the rest the rest the next year or the rest the year and i could just be able afford the money to get a new one for the next few years so that way my mom could have the car and i can afford to pay the bills for my house but she doesn’t want me and she wants me and her and my mom and her and i have a job and i can get") }
                journalEntriesPassthroughSubject.send(journalEntries)
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

        return Output(
            journalEntriesPublisher: journalEntriesPassthroughSubject.eraseToAnyPublisher()
        )
    }
}
