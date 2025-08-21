//
//  Router+Extensions.swift
//  Core
//
//  Created by Dmytro Yantsybaiev on 18.08.2025.
//

public extension Router.StartFlowRoute {

    func start() {
        start(completion: nil)
    }
}

public extension Router.FinishFlowRoute {

    func finishFlow() {
        finishFlow(completion: nil)
    }
}

public extension Router.ResetFlowRoute {

    func resetFlow() {
        resetFlow(completion: nil)
    }
}
