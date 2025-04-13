//
//  DI+Repositories.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

import Factory

extension Container {
    var getCarRepository: Factory<CarRepositoryProtocol> {
        self { CarRepository() }.singleton
    }
    
    var getTrafficLightRepository: Factory<TrafficLightRepositoryProtocol> {
        self { TrafficLightRepository() }.singleton
    }
}
