//
//  FakeCarRepository.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import Foundation
@testable import KBC_task

/// A fake repository to use in our unit tests
final class FakeCarRepository: CarRepositoryProtocol {
    
    @Published private var car: Car?
    var carPublisher: Published<Car?>.Publisher { $car }
    
    // This property is not in the protocol but is available in tests
    private(set) var lastSetCar: Car?
    
    func setCar(car: Car) {
        self.lastSetCar = car
        self.car = car
    }
    
}
