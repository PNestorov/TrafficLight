//
//  GetCarPublisherUCTests.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
import Combine
import Factory
@testable import KBC_task

final class GetCarPublisherUCTests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var getCarPublisherUC: GetCarPublisherUCProtocol!
    var fakeCarRepository: FakeCarRepository!
    var cancellables: Set<AnyCancellable>!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        fakeCarRepository = FakeCarRepository()
        cancellables = []
        
        // Override the DI registration so that any @Injected(\.getCarRepository) returns our fakeCarRepository
        Container.registerMock(carRepository: fakeCarRepository)
        
        getCarPublisherUC = GetCarPublisherUC()
        
    }
    
    override func tearDownWithError() throws {
        
        // Reset the Factory registration so it doesn’t affect other tests
        Container.shared.getCarRepository.reset()
        fakeCarRepository = nil
        getCarPublisherUC = nil
        cancellables = nil
        
        try super.tearDownWithError()
        
    }
    
    // MARK: - Tests
    
    /// Test that updating the fake repository triggers the publisher to emit the new value
    func testPublisherEmitsUpdatedCar() throws {
        
        // GIVEN: A new Car instance to be set in the repository
        let testCar = Car(modelName: "Alfa Romeo")
        
        // WHEN: We subscribe to the publisher (ignoring the initial nil value) and then update the repository
        let publisher = getCarPublisherUC.invoke()
        let expectationUpdate = expectation(description: "Publisher should emit updated car value after setCar is called")
        
        publisher
            .dropFirst() // Skip the initial nil emission
            .sink { car in
                if car == testCar {
                    expectationUpdate.fulfill()
                }
            }
            .store(in: &cancellables)
        
        // Act: Update the fake repository
        fakeCarRepository.setCar(car: testCar)
        
        // THEN: The publisher should emit the updated testCar
        wait(for: [expectationUpdate], timeout: 1.0)
        
    }
    
}
