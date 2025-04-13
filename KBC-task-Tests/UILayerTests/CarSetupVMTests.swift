//
//  CarSetupVMTests.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
import Combine
import Factory
@testable import KBC_task

@MainActor
final class CarSetupVMTests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var carSetupVM: CarSetupVM!
    var fakeCarRepository: FakeCarRepository!
    var fakeCarValidationUC: FakeCarValidationUC!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        fakeCarRepository = FakeCarRepository()
        fakeCarValidationUC = FakeCarValidationUC()
        cancellables = []
        
        // Override DI registrations so that injected dependencies resolve to our fakes
        Container.registerMocks(carRepository: fakeCarRepository,
                                carValidationUC: fakeCarValidationUC)
        
        // Create the view model after registering so it uses the fakes
        carSetupVM = CarSetupVM()
        
    }
    
    override func tearDownWithError() throws {
        
        Container.shared.getCarRepository.reset()
        Container.shared.getCarValidationUC.reset()
        
        carSetupVM = nil
        fakeCarRepository = nil
        fakeCarValidationUC = nil
        cancellables = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    /// Ensure that the initial state of the view model is clean
    func testInitialState() throws {
        
        // Upon creation, carModel should be empty and errorMessage nil
        XCTAssertEqual(carSetupVM.carModel, "")
        XCTAssertNil(carSetupVM.errorMessage)
        
    }
    
    /// Successful scenario
    func testOnStartDrivingSuccessful() throws {
        
        // GIVEN: A valid car model
        let validCarModel = "Alfa Rmoeo"
        carSetupVM.carModel = validCarModel
        fakeCarValidationUC.resultToReturn = .success(())
        
        let navigationExpectation = expectation(description: "Navigation event should be sent")
        var receivedScreen: Screen?
        
        carSetupVM.pushScreenNavigationEvent
            .sink { screen in
                receivedScreen = screen
                navigationExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // WHEN: The button is pressed
        carSetupVM.onStartDrivingButtonPressed()
        
        // THEN: Check that errorMessage is nil and the repository was updated
        XCTAssertNil(carSetupVM.errorMessage)
        
        // Here we use our fake's extra property for simplicity
        XCTAssertEqual(fakeCarRepository.lastSetCar, Car(modelName: validCarModel))
        
        wait(for: [navigationExpectation], timeout: 1.0)
        XCTAssertEqual(receivedScreen, .trafficLight)
        
    }
    
    /// Failure scenario:
    ///
    /// In this case, validation fails so:
    /// - An error message is set
    /// - The repository is not updated
    /// - No navigation event should be fired
    func testOnStartDrivingFailure() throws {
        
        // GIVEN: An invalid car model.
        let invalidCarModel = "AR"
        carSetupVM.carModel = invalidCarModel
        
        // Configure the fake validation to return a failure
        struct TestError: Error, Equatable {}
        let testError = CarValidationError.tooShortModelName(modelName: carSetupVM.carModel)
        fakeCarValidationUC.resultToReturn = .failure(testError)
        
        // Set up an inverted expectation to verify no navigation event is sent
        let navExpectation = expectation(description: "Navigation event should NOT be sent")
        navExpectation.isInverted = true
        
        carSetupVM.pushScreenNavigationEvent
            .sink { _ in
                navExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        // WHEN: The Start Driving button is pressed
        carSetupVM.onStartDrivingButtonPressed()
        
        // THEN:
        // 1. Verify that an appropriate error message is set
        XCTAssertEqual(carSetupVM.errorMessage, String(describing: testError))
        
        // 2. Verify that the repository was not updated
        XCTAssertNil(fakeCarRepository.lastSetCar)
        
        // 3. Verify that no navigation event was fired
        wait(for: [navExpectation], timeout: 1.0)
        
    }
    
}
