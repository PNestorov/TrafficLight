//
//  TrafficLightCircle.swift
//  KBC-task
//
//  Created by Petar Nestorov on 11.04.25.
//

import SwiftUI

struct TrafficLightCircle: View {
    
    private static let ActiveOpacity: Double = 1.0
    private static let InactiveOpacity: Double = 0.3
    private static let GlowOpacity: Double = 0.6
    private static let GlowRadius: CGFloat = 20.0
    private static let NoGlowRadius: CGFloat = 0.0
    
    let color: Color
    let isActive: Bool
    var size: CGFloat = 100
    
    var body: some View {
        Circle()
            .fill(color.opacity(isActive ? Self.ActiveOpacity : Self.InactiveOpacity))
            .frame(width: size, height: size)
            .shadow(color: isActive ? color.opacity(Self.GlowOpacity) : .clear,
                    radius: isActive ? Self.GlowRadius : Self.NoGlowRadius)
            .animation(.easeInOut, value: isActive)
    }
    
}
