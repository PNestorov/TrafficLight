//
//  TrafficLightRepositoryTests.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
import Combine
@testable import KBC_task

final class TrafficLightRepositoryTests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var trafficLightRepository: TrafficLightRepositoryProtocol!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        trafficLightRepository = TrafficLightRepository()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        trafficLightRepository.stopTrafficCycle()
        trafficLightRepository = nil
        cancellables = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    /// Test that starting the traffic cycle results in the expected state transitions
    ///
    /// Expected cycle (Version 1):
    /// - At t = 0, state is .green
    /// - After greenDuration (4 seconds), state should become .orange
    /// - After orangeDuration (1 second) from .orange (with previous = .green), state becomes .red
    /// - After redDuration (4 seconds), state becomes .orange
    /// - After orangeDuration (1 second) from .orange (with previous = .red), state becomes .green
    ///
    /// Note: This test will wait approximately 10 seconds
    func testTrafficCycleTransitions() throws {
        
        // Expectation for each state transition
        let expectationGreenToOrange = expectation(description: "State changes from green to orange")
        let expectationOrangeToRed = expectation(description: "State changes from orange to red")
        let expectationRedToOrange = expectation(description: "State changes from red to orange")
        let expectationOrangeToGreen = expectation(description: "State changes from orange to green")
        
        var states: [TrafficLightState] = []
        
        trafficLightRepository.currentStatePublisher
            .dropFirst() // This drops the initial automatic .green emitted on subscription
            .sink { state in
                states.append(state)
                
                // When 2nd emission occurs, it should be orange
                if states.count == 2, state == .orange {
                    expectationGreenToOrange.fulfill()
                }
                // When 3rd emission occurs, it should be red
                if states.count == 3, state == .red {
                    expectationOrangeToRed.fulfill()
                }
                // When 4th emission occurs, it should be orange
                if states.count == 4, state == .orange {
                    expectationRedToOrange.fulfill()
                }
                // When 5th emission occurs, it should be green
                if states.count == 5, state == .green {
                    expectationOrangeToGreen.fulfill()
                }
            }
            .store(in: &cancellables)
        
        trafficLightRepository.startTrafficCycle()
        
        // Wait for the expected transitions. Total timeout of 15 seconds allows margin for timing delays
        wait(for: [expectationGreenToOrange, expectationOrangeToRed, expectationRedToOrange, expectationOrangeToGreen], timeout: 15.0)
        
        // Verify the sequence
        XCTAssertEqual(states, [.green, .orange, .red, .orange, .green])
        
    }
    
    /// Test that stopping the traffic cycle prevents further state transitions
    func testStopTrafficCyclePreventsFurtherTransitions() throws {
        
        // Create an inverted expectation to assert that no additional state change occurs
        let expectationNoTransition = expectation(description: "No state transition should occur after stopping")
        expectationNoTransition.isInverted = true
        
        var changeCount = 0
        
        trafficLightRepository.currentStatePublisher
            .dropFirst() // This drops the initial automatic .green emitted on subscription
            .sink { _ in
                changeCount += 1
                
                if changeCount > 1 {
                    expectationNoTransition.fulfill()
                }
            }
            .store(in: &cancellables)
        
        trafficLightRepository.startTrafficCycle()
        
        // Immediately stop the cycle so the timer will be invalidated
        trafficLightRepository.stopTrafficCycle()
        
        // Wait 5 seconds to see if any additional state changes occur (expect none)
        wait(for: [expectationNoTransition], timeout: 5.0)
        
        // Verify that only the initial state (green) was emitted
        XCTAssertEqual(changeCount, 1)
        
    }
    
}
