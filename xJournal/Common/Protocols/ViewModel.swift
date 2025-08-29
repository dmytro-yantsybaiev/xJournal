//
//  ViewModel.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

@MainActor
protocol ViewModel: AnyObject {

    associatedtype Input
    associatedtype Output

    func transform(_ input: Input) -> Output
}
