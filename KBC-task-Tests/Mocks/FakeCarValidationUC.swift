//
//  FakeCarValidationUC.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
@testable import KBC_task

/// Fake for CarValidationUCProtocol to control validation outcome
final class FakeCarValidationUC: CarValidationUCProtocol {
    
    /// Set the result you want validation to return
    var resultToReturn: Result<Void, Error> = .success(())
    
    func invoke(car: Car) -> Result<Void, Error> {
        return resultToReturn
    }
    
}
