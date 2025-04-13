//
//  CarSetupVM.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

import Foundation
import Factory
import Combine

final class CarSetupVM: BaseVM {
    
    // MARK: - Properties
    
    @Published var carModel: String = ""
    @Published var errorMessage: String?
    
    // MARK: - Dependencies
    
    @Injected(\.getCarValidationUC) private var getCarValidationUC
    @Injected(\.getCarRepository) private var carRepository
    
    // MARK: - Methods
    
    func onStartDrivingButtonPressed() {
        
        let car = Car(modelName: carModel)
        
        let getCarValidationResult = getCarValidationUC.invoke(car: car)
        switch getCarValidationResult {
        case .success:
            errorMessage = nil
            carRepository.setCar(car: car)
            pushScreenNavigationEvent.send(.trafficLight)
            
        case .failure(let error):
            errorMessage = String(describing: error)
        }
        
    }
    
}
