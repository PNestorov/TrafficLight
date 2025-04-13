//
//  CarRepositoryTests.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
import Combine
@testable import KBC_task

final class CarRepositoryTests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var carRepository: CarRepositoryProtocol!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        carRepository = CarRepository()
        cancellables = []
    }
    
    override func tearDownWithError() throws {
        cancellables = nil
        carRepository = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    /// Test that calling setCar(car:) publishes the new car
    func testSetCarPublishesNewCar() throws {
        
        let expectedCar = Car(modelName: "Giulia")
        
        let newCarExpectation = expectation(description: "Publisher should emit the new car value after setting a car")
        
        carRepository.carPublisher
            .dropFirst() // Skip the initial nil emission
            .sink { car in
                XCTAssertEqual(car?.modelName, expectedCar.modelName,
                               "The published car's model name should match the test car's model name.")
                newCarExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        carRepository.setCar(car: expectedCar)
        
        wait(for: [newCarExpectation], timeout: 1.0)
        
    }
    
}
