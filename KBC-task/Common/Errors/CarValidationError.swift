//
//  CarValidationError.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

enum CarValidationError: Error, Equatable {
    case tooShortModelName(modelName: String)
}

extension CarValidationError: CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .tooShortModelName(let modelName):
            return "Invalid car model: '\(modelName)'. Must be at least 3 characters."
        }
    }
    
}
