//
//  GetCarPublisherUC.swift
//  KBC-task
//
//  Created by Petar Nestorov on 11.04.25.
//

import Foundation
import Factory

protocol GetCarPublisherUCProtocol {
    func invoke() -> Published<Car?>.Publisher
}


class GetCarPublisherUC: GetCarPublisherUCProtocol {
    
    @Injected(\.getCarRepository) private var carRepository
    
    func invoke() -> Published<Car?>.Publisher {
        return carRepository.carPublisher
    }
    
}
