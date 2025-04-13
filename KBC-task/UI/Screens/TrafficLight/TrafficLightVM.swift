//
//  TrafficLightVM.swift
//  KBC-task
//
//  Created by Petar Nestorov on 11.04.25.
//

import Foundation
import Combine
import Factory

final class TrafficLightVM: BaseVM {
    
    // MARK: - Properties
    
    @Published var currentLight: TrafficLightState = .green
    @Published var carModel: String = ""
    @Published private var carPublisher: Car?
        
    // MARK: - Dependencies
    
    @Injected(\.getCarPublisherUC) private var getCarPublisherUC
    @Injected(\.getTrafficLightRepository) private var trafficLightRepository
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        
        bindCarPublisher()
        bindTrafficLightRepository()
    }
    
    // MARK: - Private Binding Methods
    
    /// Subscribes to car updates and updates the car model.
    private func bindCarPublisher() {
        getCarPublisherUC.invoke()
            .assign(to: &$carPublisher)
        
        $carPublisher
            .compactMap { $0 }
            .sink { [weak self] newCar in
                self?.carModel = newCar.modelName
            }
            .store(in: &cancellables)
    }
    
    /// Subscribes to traffic light state changes.
    private func bindTrafficLightRepository() {
        trafficLightRepository.currentStatePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newState in
                self?.currentLight = newState
            }
            .store(in: &cancellables)
    }
    
    
    // MARK: - Public Methods
    
    func startTrafficLightCycle() {
        trafficLightRepository.startTrafficCycle()
    }
    
    func stopTrafficLightCycle() {
        trafficLightRepository.stopTrafficCycle()
    }
    
}
