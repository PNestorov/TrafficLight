//
//  TrafficLightScreen.swift
//  KBC-task
//
//  Created by Petar Nestorov on 11.04.25.
//

import SwiftUI

struct TrafficLightScreen: View {
    
    @StateObject private var viewModel = TrafficLightVM()
    
    var body: some View {
        
        VStack(spacing: 40) {
            carModelNameText
            trafficLightCircles
        }
        .onAppear {
            viewModel.startTrafficLightCycle()
        }
        .onDisappear {
            viewModel.stopTrafficLightCycle()
        }
        .padding()
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(AccessibilityIdentifiers.Screens.TrafficLightScreen)
        
    }
    
    // MARK: - Texts
    
    private var carModelNameText: some View {
        Text(viewModel.carModel)
            .font(.largeTitle)
            .accessibilityIdentifier(AccessibilityIdentifiers.Texts.CarModelNameText)
    }
    
    // MARK: - TrafficLightCircles
    
    private var trafficLightCircles: some View {
        VStack(spacing: 20) {
            TrafficLightCircle(color: .red, isActive: viewModel.currentLight == .red)
                .accessibilityIdentifier(AccessibilityIdentifiers.TrafficLightCircles.TrafficLightCircleRed)
            
            TrafficLightCircle(color: .orange, isActive: viewModel.currentLight == .orange)
                .accessibilityIdentifier(AccessibilityIdentifiers.TrafficLightCircles.TrafficLightCircleOrange)
            
            TrafficLightCircle(color: .green, isActive: viewModel.currentLight == .green)
                .accessibilityIdentifier(AccessibilityIdentifiers.TrafficLightCircles.TrafficLightCircleGreen)
        }
    }
    
}


#Preview {
    TrafficLightScreen()
}
