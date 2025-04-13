//
//  FakeGetCarPublisherUC.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import Combine
@testable import KBC_task

/// Fake for GetCarPublisherUCProtocol that exposes a controllable @Published property
final class FakeGetCarPublisherUC: GetCarPublisherUCProtocol {
    
    @Published var car: Car? = nil
    
    func invoke() -> Published<Car?>.Publisher {
        return $car
    }
    
}
