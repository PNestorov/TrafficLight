//
//  CoordinatorModels.swift
//  KBC-task
//
//  Created by Petar Nestorov on 10.04.25.
//


enum Screen: String, Identifiable {
    case carSetup, trafficLight
    
    var id: String {
        self.rawValue
    }
}


enum Sheet: String, Identifiable {
    case sheetPlaceholder
    
    var id: String {
        self.rawValue
    }
}


enum FullScreenCover: String, Identifiable {
    case fullScreenCoverPlaceholder
    
    var id: String {
        self.rawValue
    }
}
