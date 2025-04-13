//
//  CarValidationUC.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

protocol CarValidationUCProtocol {
    
    /// Validates a given Car instance.
    /// - Parameter car: The Car object to validate.
    /// - Returns: `.success` if valid, `.failure` with a specific validation error if invalid.
    func invoke(car: Car) -> Result<Void, Error>
    
}


class CarValidationUC: CarValidationUCProtocol {
    
    // Minimum allowed length for a car's model name after trimming spaces.
    private let minModelNameLength: Int = 3
    
    func invoke(car: Car) -> Result<Void, Error> {
        
        let trimmedModelName = car.modelName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if ( trimmedModelName.count < minModelNameLength ) {
            return .failure(CarValidationError.tooShortModelName(modelName: car.modelName))
        } else {
            return .success(())
        }
        
    }
    
}
