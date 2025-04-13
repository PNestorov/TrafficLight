//
//  TrafficLightRepository.swift
//  KBC-task
//
//  Created by Petar Nestorov on 11.04.25.
//

import Combine
import Foundation

enum TrafficLightState {
    case green, orange, red
}

protocol TrafficLightRepositoryProtocol {
    var currentStatePublisher: Published<TrafficLightState>.Publisher { get }
    func startTrafficCycle()
    func stopTrafficCycle()
}


final class TrafficLightRepository: TrafficLightRepositoryProtocol {
    
    // MARK: - Properties
    
    @Published private var currentState: TrafficLightState = .green
    var currentStatePublisher: Published<TrafficLightState>.Publisher { $currentState }
    
    private var timer: Timer?
    private var previousState: TrafficLightState = .green
    
    
    // MARK: - Timing Constants
    private let greenDuration: TimeInterval = 4
    private let orangeDuration: TimeInterval = 1
    private let redDuration: TimeInterval = 4
    
    
    // MARK: - Instance methods
    
    /// Starts the traffic light cycle from the green state.
    func startTrafficCycle() {
        currentState = .green
        previousState = .green
        scheduleNextTransition(after: greenDuration)
    }
    
    /// Schedules the next traffic light state transition after a given time interval.
    private func scheduleNextTransition(after seconds: TimeInterval) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: seconds, repeats: false) { [weak self] _ in
            self?.changeState_V1()
        }
    }
    
    /// Changes traffic light states following Version 1 cycle logic.
    ///
    /// Note: "Classic traffic light" cycles vary by country.
    /// - Version 1: Green → Orange → Red → Orange → Green
    /// - Version 2: Green → Orange → Red → Green
    /// Therefore, two method variations are provided.
    private func changeState_V1() {
        
        switch currentState {
        case .green:
            previousState = .green
            currentState = .orange
            scheduleNextTransition(after: orangeDuration)
        case .orange:
            if previousState == .green {
                previousState = .orange
                currentState = .red
                scheduleNextTransition(after: redDuration)
            } else if previousState == .red {
                previousState = .orange
                currentState = .green
                scheduleNextTransition(after: greenDuration)
            }
        case .red:
            previousState = .red
            currentState = .orange
            scheduleNextTransition(after: orangeDuration)
        }
        
    }
    
    private func changeState_V2() {
        
        switch currentState {
        case .green:
            currentState = .orange
            scheduleNextTransition(after: orangeDuration)
        case .orange:
            currentState = .red
            scheduleNextTransition(after: redDuration)
        case .red:
            currentState = .green
            scheduleNextTransition(after: greenDuration)
        }
        
    }
    
    /// Stops the traffic light cycle and invalidates any running timer.
    func stopTrafficCycle() {
        timer?.invalidate()
        timer = nil
    }
    
}
