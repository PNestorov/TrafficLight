//
//  AppCoordinator.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//

import SwiftUI

/// Central coordinator that manages navigation, sheet presentation, and full-screen covers.
class AppCoordinator: ObservableObject {
    
    // MARK: - Properties
    
    /// Navigation stack path for push/pop screens.
    @Published var path = NavigationPath()
    
    /// Currently active sheet (if any).
    @Published var sheet: Sheet?
    
    /// Currently active full-screen cover (if any).
    @Published var fullScreenCover: FullScreenCover?
    
    // MARK: - Navigation Methods
    
    /// Pushes a new screen onto the navigation stack.
    func push(_ screen: Screen) {
        path.append(screen)
    }
    
    /// Presents a modal sheet.
    func present(sheet: Sheet) {
        self.sheet = sheet
    }
    
    /// Presents a full-screen cover.
    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }
    
    /// Pops the last screen from the navigation stack.
    func pop() {
        path.removeLast()
    }
    
    /// Pops all screens and returns to the root view.
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    /// Dismisses the currently presented sheet.
    func dismissSheet() {
        self.sheet = nil
    }
    
    /// Dismisses the currently presented full-screen cover.
    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }
    
    // MARK: - Screen Builders
    
    /// Builds the destination view for a pushed screen.
    @ViewBuilder
    func build(screen: Screen) -> some View {
        switch screen {
        case .carSetup:
            CarSetupScreen()
        case .trafficLight:
            TrafficLightScreen()
        }
    }
    
    /// Builds the destination view for a sheet.
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .sheetPlaceholder:
            NavigationStack {
                // TODO: SheetPlaceholderView()
            }
        }
    }
    
    /// Builds the destination view for a full-screen cover.
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .fullScreenCoverPlaceholder:
            NavigationStack {
                // TODO: FullScreenCoverPlaceholderView()
            }
        }
    }
    
}
