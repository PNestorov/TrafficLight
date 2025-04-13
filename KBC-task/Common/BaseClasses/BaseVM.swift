//
//  BaseVM.swift
//  KBC-task
//
//  Created by Petar Nestorov on 13.04.25.
//

import Foundation
import Combine
import SwiftUI

@MainActor class BaseVM: ObservableObject {
    
    /// Emits a navigation event to move to the next screen.
    let pushScreenNavigationEvent = PassthroughSubject<Screen, Never>()
        
    var className: String {
        String(describing: Self.self)
    }
    
    ///Used to store different observers
    var cancellables = Set<AnyCancellable>()
    
    
    
    deinit {
        // Used for debug purposes
//        let className = String(describing: Self.self)
//        NSLog("deinit " + className)
    }
    
}
