//
//  CarRepository.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

import Foundation

protocol CarRepositoryProtocol {
    var carPublisher: Published<Car?>.Publisher { get }
    func setCar(car: Car)
}

final class CarRepository: CarRepositoryProtocol {
    
    // MARK: - Properties
    
    @Published private var car: Car?
    var carPublisher: Published<Car?>.Publisher { $car }
    
    // MARK: - Methods
    
    func setCar(car: Car) {
        self.car = car
    }
    
}
