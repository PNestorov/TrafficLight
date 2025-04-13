//
//  CarSetupScreen.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

import SwiftUI
import Factory

struct CarSetupScreen: View {
    
    @StateObject private var viewModel = CarSetupVM()
    @Injected(\.getAppCoordinator) private var appCoordinator
    
    var body: some View {
        
        VStack(spacing: 16) {
            
            enterCarModelText
            carModelTextField
            
            if let error = viewModel.errorMessage {
                errorText(error)
            }
            
            startDrivingButton
            
        }
        .padding()
        .onReceive(viewModel.pushScreenNavigationEvent) { screen in
            appCoordinator.push(screen)
        }
        .accessibilityElement(children: .contain)
        .accessibilityIdentifier(AccessibilityIdentifiers.Screens.CarSetupScreen)
        
    }
    
    
    // MARK: - Texts
    
    private var enterCarModelText: some View {
        Text("Enter your Car Model:")
            .font(.headline)
    }
    
    private func errorText(_ error: String) -> some View {
        Text(error)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .transition(.move(edge: .top).combined(with: .opacity))
            .accessibilityIdentifier(AccessibilityIdentifiers.Texts.ErrorText)
    }
    
    // MARK: - TextFields
    
    private var carModelTextField: some View {
        TextField("Car Model", text: $viewModel.carModel)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal)
            .submitLabel(.done)
            .onSubmit {
                viewModel.onStartDrivingButtonPressed()
            }
            .accessibilityIdentifier(AccessibilityIdentifiers.TextFields.CarModelTextField)
    }
    
    // MARK: - Buttons
    
    private var startDrivingButton: some View {
        Button(action: {
            viewModel.onStartDrivingButtonPressed()
        }) {
            Text("Start Driving")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .accessibilityIdentifier(AccessibilityIdentifiers.Buttons.StartDrivingButton)
    }
    
}

#Preview {
    CarSetupScreen()
}
