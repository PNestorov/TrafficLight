//
//  TrafficLightVMTests.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
import Combine
import Factory
@testable import KBC_task

@MainActor
final class TrafficLightVMTests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var trafficLightVM: TrafficLightVM!
    var fakeTrafficLightRepository: FakeTrafficLightRepository!
    var fakeCarPublisherUC: FakeGetCarPublisherUC!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    @MainActor override func setUpWithError() throws {
        try super.setUpWithError()
        
        fakeTrafficLightRepository = FakeTrafficLightRepository()
        fakeCarPublisherUC = FakeGetCarPublisherUC()
        cancellables = []
        
        // Override DI registrations so that injected dependencies resolve to our fakes
        Container.registerMocks(trafficLightRepository: fakeTrafficLightRepository,
                                       getCarPublisherUC: fakeCarPublisherUC)
        
        // Now instantiate the view model so that it uses our fakes
        trafficLightVM = TrafficLightVM()
        
    }
    
    override func tearDownWithError() throws {
        
        Container.shared.getCarPublisherUC.reset()
        Container.shared.getTrafficLightRepository.reset()
        
        trafficLightVM = nil
        fakeCarPublisherUC = nil
        fakeTrafficLightRepository = nil
        cancellables = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    /// Test that when the car publisher emits a new Car, the view model's carModel binding updates accordingly
    func testCarModelBinding() throws {
        
        // GIVEN: Initially, carModel is empty
        XCTAssertEqual(trafficLightVM.carModel, "")
        
        let expectedModel = "Alfa Romeo"
        let updateExpectation = expectation(description: "carModel should update to \(expectedModel)")
        
        trafficLightVM.$carModel
            .dropFirst() // Ignore the initial emission
            .sink { newValue in
                if newValue == expectedModel {
                    updateExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // WHEN: Fake publisher updates with a new Car
        fakeCarPublisherUC.car = Car(modelName: expectedModel)
        
        // THEN: Wait until the binding updates and verify
        wait(for: [updateExpectation], timeout: 1.0)
        XCTAssertEqual(trafficLightVM.carModel, expectedModel)
        
    }
    
    /// Test that when the fake traffic light repository changes its state, the view model's currentLight binding is updated accordingly
    func testTrafficLightStateBinding() throws {
        
        // GIVEN: Initially, currentLight is .green
        XCTAssertEqual(trafficLightVM.currentLight, .green)
        
        let stateExpectation = expectation(description: "currentLight should update to .orange")
        
        trafficLightVM.$currentLight
            .dropFirst() // Skip initial value
            .sink { newState in
                if newState == .orange {
                    stateExpectation.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // WHEN: Simulate a state change
        fakeTrafficLightRepository.currentState = .orange
        
        // THEN: The binding should update
        wait(for: [stateExpectation], timeout: 1.0)
        XCTAssertEqual(trafficLightVM.currentLight, .orange)
        
    }
    
    /// Test that calling startTrafficLightCycle on the view model calls the underlying repository
    func testStartTrafficLightCycleForwarding() throws {
        
        // GIVEN: The fake repository has not yet been triggered
        XCTAssertFalse(fakeTrafficLightRepository.didCallStartTrafficCycle)
        
        // WHEN: The view model starts the traffic light cycle
        trafficLightVM.startTrafficLightCycle()
        
        // THEN: The fake repository should record the call
        XCTAssertTrue(fakeTrafficLightRepository.didCallStartTrafficCycle)
        
    }
    
    /// Test that calling stopTrafficLightCycle on the view model calls the underlying repository
    func testStopTrafficLightCycleForwarding() throws {
        
        // GIVEN: The fake repository has not yet been triggered
        XCTAssertFalse(fakeTrafficLightRepository.didCallStopTrafficCycle)
        
        // WHEN: The view model stops the traffic light cycle
        trafficLightVM.stopTrafficLightCycle()
        
        // THEN: The fake repository should record the call
        XCTAssertTrue(fakeTrafficLightRepository.didCallStopTrafficCycle)
        
    }
    
}
