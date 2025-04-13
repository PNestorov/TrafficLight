//
//  CarSetupScreen_UITests.swift
//  KBC-task-UITests
//
//  Created by Petar Nestorov on 12.04.25.
//

import XCTest
import KBC_task

final class CarSetupScreen_UITests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var app: XCUIApplication!
    
    // MARK: - Setup & Teardown
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Launch the application.
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Tests
    
    /// Tests that entering a valid car model and tapping "Start Driving" causes navigation to the next screen (TrafficLightScreen) and no error is displayed.
    func testValidCarModelShouldNavigateToNextScreen() throws {
        
        // GIVEN: The CarSetupScreen should be visible
        let carSetupScreen = app.otherElements[AccessibilityIdentifiers.Screens.CarSetupScreen]
        XCTAssertTrue(carSetupScreen.waitForExistence(timeout: 1), "Car Setup Screen did not appear.")
        
        let modelName = "Alfa"
        
        // WHEN: Enter a valid car model into the text field
        let carTextField = app.textFields[AccessibilityIdentifiers.TextFields.CarModelTextField]
        XCTAssertTrue(carTextField.exists, "Car Model text field does not exist.")
        
        carTextField.tap()
        carTextField.typeText(modelName)
        
        let startDrivingButton = app.buttons[AccessibilityIdentifiers.Buttons.StartDrivingButton]
        XCTAssertTrue(startDrivingButton.exists, "Start Driving button does not exist.")
        startDrivingButton.tap()
        
        let trafficLightScreen = app.otherElements[AccessibilityIdentifiers.Screens.TrafficLightScreen]
        
        // THEN: Verify that no error text is displayed
        let errorText = app.staticTexts[AccessibilityIdentifiers.Texts.ErrorText]
        XCTAssertFalse(errorText.waitForExistence(timeout: 3), "Error text should not be displayed for a valid car model.")
        
        // Verify that the Traffic Light screen is presented
        XCTAssertTrue(trafficLightScreen.waitForExistence(timeout: 1), "The TrafficLightScreen should be presented.")
        
    }
    
    /// Tests that entering an invalid car model (e.g. too short) and tapping "Start Driving" displays the expected error message and no navigation occurs
    func testInvalidCarModelShouldDisplayError() throws {
        
        // GIVEN: The CarSetupScreen must be visible
        let carSetupScreen = app.otherElements[AccessibilityIdentifiers.Screens.CarSetupScreen]
        XCTAssertTrue(carSetupScreen.waitForExistence(timeout: 1), "Car Setup Screen did not appear.")
        
        // WHEN: Enter an invalid car model (too short)
        let carTextField = app.textFields[AccessibilityIdentifiers.TextFields.CarModelTextField]
        XCTAssertTrue(carTextField.exists, "Car Model text field does not exist.")
        carTextField.tap()
        carTextField.typeText("AR")
        
        let startDrivingButton = app.buttons[AccessibilityIdentifiers.Buttons.StartDrivingButton]
        XCTAssertTrue(startDrivingButton.exists, "Start Driving button does not exist.")
        startDrivingButton.tap()
        
        // THEN: Verify that the error text appears
        let errorText = app.staticTexts[AccessibilityIdentifiers.Texts.ErrorText]
        XCTAssertTrue(errorText.waitForExistence(timeout: 1), "The Error text for should appear on the screen.")
        
        // Verify that the Traffic Light screen is NOT presented
        let trafficLightScreen = app.otherElements[AccessibilityIdentifiers.Screens.TrafficLightScreen]
        XCTAssertFalse(trafficLightScreen.waitForExistence(timeout: 1), "The TrafficLightScreen should NOT be presented.")
        
    }
    
}
