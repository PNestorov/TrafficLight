//
//  FakeTrafficLightRepository.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import Combine
@testable import KBC_task

// Fake for TrafficLightRepositoryProtocol that uses @Published for state and records method calls
final class FakeTrafficLightRepository: TrafficLightRepositoryProtocol {
    
    @Published var currentState: TrafficLightState = .green
    
    var currentStatePublisher: Published<TrafficLightState>.Publisher {
        return $currentState
    }
    
    var didCallStartTrafficCycle = false
    var didCallStopTrafficCycle = false
    
    func startTrafficCycle() {
        didCallStartTrafficCycle = true
    }
    
    func stopTrafficCycle() {
        didCallStopTrafficCycle = true
    }
    
}
