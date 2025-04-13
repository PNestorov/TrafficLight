//
//  Factory+XCTest.swift
//  KBC-task
//
//  Created by Petar Nestorov on 13.04.25.
//

@testable import KBC_task
import Factory

extension Container {
    
    // MARK: - Register Mocks / Fakes
    
    /// Registers the given instances, allowing your tests to control the the mock / fake
    static func registerMock(carRepository: CarRepositoryProtocol) {
        _ = Container.shared.getCarRepository.register { carRepository }.singleton
    }
    
    /// Registers the given instances, allowing your tests to control the mocks / fakes
    static func registerMocks(carRepository: CarRepositoryProtocol,
                                     carValidationUC: CarValidationUCProtocol) {
        _ = Container.shared.getCarRepository.register { carRepository }.singleton
        _ = Container.shared.getCarValidationUC.register { carValidationUC }.unique
    }
    
    /// Registers the given instances, allowing your tests to control the mocks / fakes
    static func registerMocks(trafficLightRepository: TrafficLightRepositoryProtocol,
                                     getCarPublisherUC: GetCarPublisherUCProtocol) {
        _ = Container.shared.getTrafficLightRepository.register { trafficLightRepository }.singleton
        _ = Container.shared.getCarPublisherUC.register { getCarPublisherUC }.unique
    }
    
    /// Registers new instances of your mock / fake implementations
    static func registerAllMocks() {
        
        _ = Container.shared.getCarRepository.register { FakeCarRepository() }.singleton
        _ = Container.shared.getTrafficLightRepository.register { FakeTrafficLightRepository() }.singleton
        _ = Container.shared.getCarPublisherUC.register { FakeGetCarPublisherUC() }.unique
        _ = Container.shared.getCarValidationUC.register { FakeCarValidationUC() }.unique
        
    }
    
    static func resetMockServices() {
        Container.shared.getCarRepository.reset()
        Container.shared.getCarValidationUC.reset()
    }
    
}
