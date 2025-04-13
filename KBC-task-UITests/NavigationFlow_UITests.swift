//
//  NavigationFlow_UITests.swift
//  KBC-task-UITests
//
//  Created by Petar Nestorov on 13.04.25.
//

import XCTest

final class NavigationFlow_UITests: XCTestCase {
    
    // MARK: - System under test and resources
    
    var app: XCUIApplication!
    
    // MARK: - Setup & TearDown
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        // Launch the application.
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    /// Test that after entering a valid car model on the CarSetupScreen,
    /// tapping the Start Driving button navigates to the TrafficLightScreen
    /// and displays the same car model
    func testCarModelIsPassedFromCarSetupToTrafficLightScreen() {
        
        // GIVEN: The CarSetupScreen is on screen
        let carSetupScreen = app.otherElements[AccessibilityIdentifiers.Screens.CarSetupScreen]
        XCTAssertTrue(carSetupScreen.waitForExistence(timeout: 1), "Car Setup Screen did not appear.")
        
        // WHEN: User enters a valid car model
        let textField = app.textFields[AccessibilityIdentifiers.TextFields.CarModelTextField]
        XCTAssertTrue(textField.exists, "Car Model text field does not exist.")
        textField.tap()
        
        // Define the car model to test
        let carModel = "Alfa Romeo"
        textField.typeText(carModel)
        
        // Tap the start driving button to trigger navigation
        let startDrivingButton = app.buttons[AccessibilityIdentifiers.Buttons.StartDrivingButton]
        XCTAssertTrue(startDrivingButton.exists, "Start Driving button does not exist.")
        startDrivingButton.tap()
        
        // THEN: Verify that the TrafficLightScreen is presented
        let trafficLightScreen = app.otherElements[AccessibilityIdentifiers.Screens.TrafficLightScreen]
        XCTAssertTrue(trafficLightScreen.waitForExistence(timeout: 1), "Traffic Light Screen did not appear.")
        
        // Verify that the car model value is passed to TrafficLightScreen.
        // Here we expect that a text element with the car model is visible.
        let carModelText = app.staticTexts[AccessibilityIdentifiers.Texts.CarModelNameText]
        XCTAssertTrue(carModelText.waitForExistence(timeout: 1), "Car model label did not appear on the Traffic Light Screen.")
        XCTAssertEqual(carModelText.label, carModel, "Expected car model '\(carModel)', but found '\(carModelText.label)'.")
        
        // Verify that the 3 circles are presented on the screen
        let redCircle = app.otherElements[AccessibilityIdentifiers.TrafficLightCircles.TrafficLightCircleRed]
        XCTAssertTrue(redCircle.waitForExistence(timeout: 1), "The red light indicator did not appear.")
        
        let orangeCircle = app.otherElements[AccessibilityIdentifiers.TrafficLightCircles.TrafficLightCircleOrange]
        XCTAssertTrue(orangeCircle.waitForExistence(timeout: 1), "The orange light indicator did not appear.")
        
        let greenCircle = app.otherElements[AccessibilityIdentifiers.TrafficLightCircles.TrafficLightCircleGreen]
        XCTAssertTrue(greenCircle.waitForExistence(timeout: 1), "The green light indicator did not appear.")
        
    }
    
}
