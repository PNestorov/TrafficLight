//
//  CoordinatorView.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

import SwiftUI
import Factory

/// Root view that handles navigation and presentation based on the AppCoordinator.
struct CoordinatorView: View {
    
    @InjectedObject(\.getAppCoordinator) private var appCoordinator
    
    var body: some View {
        
        NavigationStack(path: $appCoordinator.path) {
            
            // Set .carSetup as initial screen
            appCoordinator.build(screen: .carSetup)
                
                // Handle push navigation
                .navigationDestination(for: Screen.self) { screen in
                    appCoordinator.build(screen: screen)
                }
                
                // Handle modals (sheets)
                .sheet(item: $appCoordinator.sheet) { sheet in
                    appCoordinator.build(sheet: sheet)
                }
                
                // Handle full screen covers
                .fullScreenCover(item: $appCoordinator.fullScreenCover) { fullScreenCover in
                    appCoordinator.build(fullScreenCover: fullScreenCover)
                }
            
        }
        
    }
    
}


struct CoordinatorView_Previews: PreviewProvider {
    static var previews: some View {
        CoordinatorView()
    }
}
