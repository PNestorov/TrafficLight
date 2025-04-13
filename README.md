## TrafficLight Requirements:

Create a traffic light system:
Create an app that has 2 screens.

- On the first screen there is one textview which asks your car model and a button "Start Driving" which leads to the second screen.
- Add a validation check on the car model for a minimum length of 3.
- Pass the car model name to the second screen
- On the second screen the car model is displayed at the top and below there are 3 circles aligned vertically: RED, ORANGE and GREEN.
- The color intensity of the circles should change to which light is active. They should act like a real traffic light:

* RED – 4 seconds bright
* GREEN – 4 seconds bright
* ORANGE – 1 second bright
* The lights should quickly fade when turned on or off
* This is a classic traffic light: Green → Orange → Red and back to Green in a loop

Make sure to test your code with unit tests


## Tech Stack & Architecture

- **Languages & Frameworks**:
    - Swift, SwiftUI, and Combine for reactive UI updates.

- **Acrhitecture**:
    - Clean Architecture combined with MVVM provides clear separation of concerns.
        - Domain: Core business logic and use case definitions.
        - Data: Implementation of repositories and data handling.
        - UI: SwiftUI-based views with MVVM.

- **Navigation**:
    - The Coordinator pattern centralizes navigation logic between screens.

- **Dependency Injection**:
    - Factory (integrated via CocoaPods) is used to manage and inject dependencies, facilitating easy swapping of real and test implementations.

- **Testing**:
    - XCTest for Unit and UI testing.

- **Compatibility**:
    - Designed for iOS 16 (compatible with the current and two previous iOS versions)
