//
//  AppCoordinatorTests.swift
//  KBC-task
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
import SwiftUI
@testable import KBC_task

final class AppCoordinatorTests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var appCoordinator: AppCoordinator!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        appCoordinator = AppCoordinator()
    }
    
    override func tearDownWithError() throws {
        appCoordinator = nil
        try super.tearDownWithError()
    }
    
    // MARK: - Tests
    
    /// Test push / pop / popToRoot behavior using the published path
    func testPushPopNavigation() throws {
        
        // Initially, the navigation path should be empty
        XCTAssertEqual(appCoordinator.path, NavigationPath(), "Path should be empty initially")
        
        // Push a screen
        appCoordinator.push(.carSetup)
        XCTAssertNotEqual(appCoordinator.path, NavigationPath(), "Path should not be empty after a push")
        
        // Pop the last screen
        appCoordinator.pop()
        XCTAssertEqual(appCoordinator.path, NavigationPath(), "Path should be empty after popping the only screen")
        
        // Push two screens
        appCoordinator.push(.carSetup)
        appCoordinator.push(.trafficLight)
        XCTAssertNotEqual(appCoordinator.path, NavigationPath(), "Path should not be empty after pushing multiple screens")
        
        // Pop to root
        appCoordinator.popToRoot()
        XCTAssertEqual(appCoordinator.path, NavigationPath(), "Path should be empty after popToRoot")
        
    }
    
    /// Test sheet presentation and dismissal
    func testPresentAndDismissSheet() throws {
        
        // Initially, no sheet is presented
        XCTAssertNil(appCoordinator.sheet, "Sheet should initially be nil")
        
        // Present a sheet
        appCoordinator.present(sheet: .sheetPlaceholder)
        XCTAssertEqual(appCoordinator.sheet, .sheetPlaceholder, "Sheet should be set to sheetPlaceholder after presentation")
        
        // Dismiss the sheet
        appCoordinator.dismissSheet()
        XCTAssertNil(appCoordinator.sheet, "Sheet should be nil after dismissSheet")
        
    }
    
    /// Test full-screen cover presentation and dismissal
    func testPresentAndDismissFullScreenCover() throws {
        
        // Initially, no full-screen cover is presented
        XCTAssertNil(appCoordinator.fullScreenCover, "FullScreenCover should initially be nil")
        
        // Present a full-screen cover
        appCoordinator.present(fullScreenCover: .fullScreenCoverPlaceholder)
        XCTAssertEqual(appCoordinator.fullScreenCover, .fullScreenCoverPlaceholder, "FullScreenCover should be set after presentation")
        
        // Dismiss the full-screen cover
        appCoordinator.dismissFullScreenCover()
        XCTAssertNil(appCoordinator.fullScreenCover, "FullScreenCover should be nil after dismissal")
        
    }
    
}
