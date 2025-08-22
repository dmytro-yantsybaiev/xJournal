//
//  BaseViewController.swift
//  xJournal
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

import UIKit
import Combine

class BaseViewController: UIViewController, Storyboardable {

    lazy var viewDidLoadPassthroughSubject = PassthroughSubject<Void, Never>()
    lazy var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }

    func configure() {
        // default implementation
    }

    func bind() {
        // default implementation
    }

    func sendViewDidLoad() {
        viewDidLoadPassthroughSubject.send()
    }
}
