//
//  CarValidationUCTests.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
@testable import KBC_task

final class CarValidationUCTests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var carValidationUC: CarValidationUCProtocol!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        carValidationUC = CarValidationUC()
    }
    
    override func tearDownWithError() throws {
        carValidationUC = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    /// Test that a valid car model (i.e. trimmed model name length >= 3) produces .success
    func testInvokeValidCar() throws {
        
        let car = Car(modelName: "Giulia")
        let result = carValidationUC.invoke(car: car)
        
        switch result {
        case .success:
            // Success: Nothing to assert further
            break
        case .failure(let error):
            XCTFail("Expected success but received error: \(error)")
        }
    }
    
    /// Test that a car with a model name shorter than the minimum (after trimming) produces the expected error
    func testInvokeInvalidCarTooShortModelName() throws {
        
        let car = Car(modelName: "G")
        let result = carValidationUC.invoke(car: car)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to too short model name, but got success.")
        case .failure(let error):
            guard let validationError = error as? CarValidationError else {
                XCTFail("Expected CarValidationError but got different error type: \(error)")
                return
            }
            XCTAssertEqual(validationError, CarValidationError.tooShortModelName(modelName: car.modelName))
        }
        
    }
    
    /// Test that the validator properly trims whitespace and then validates the model name
    func testInvokeTrimsWhitespace() throws {
        
        // "  AR " when trimmed becomes "AR" which is too short
        let car = Car(modelName: "  AR ")
        let result = carValidationUC.invoke(car: car)
        
        switch result {
        case .success:
            XCTFail("Expected failure due to trimmed string with length less than minimum, but got success.")
        case .failure(let error):
            guard let validationError = error as? CarValidationError else {
                XCTFail("Expected CarValidationError but got different error type: \(error)")
                return
            }
            XCTAssertEqual(validationError, CarValidationError.tooShortModelName(modelName: car.modelName))
        }
        
    }
    
    /// Test that a car with exactly the minimum required characters (after trimming) is considered valid
    func testInvokeEdgeCaseWithExactMinLength() throws {
        
        // With a string that becomes exactly 3 characters after trimming
        let car = Car(modelName: " ARG ")  // Trims to "ARG"
        let result = carValidationUC.invoke(car: car)
        
        switch result {
        case .success:
            // Success as expected.
            break
        case .failure(let error):
            XCTFail("Expected success with a model name of exact minimum length but got error: \(error)")
        }
        
    }
    
}
