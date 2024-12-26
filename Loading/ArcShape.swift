//
//  ArcShape.swift
//  Loading
//
//  Created by HEssam on 12/26/24.
//

import SwiftUI

struct ArcShape: Shape {
    
    var fromPosition: CGFloat
    var endPosition: CGFloat
    
    var animatableData: AnimatablePair<CGFloat, CGFloat> {
        get { .init(fromPosition, endPosition) }
        set {
            fromPosition = newValue.first
            endPosition = newValue.second
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let center = CGPoint(x: rect.midX, y: rect.maxY)
        let radius = rect.width / 2
        
        let startAngle = Angle.degrees(180 * (1 - (fromPosition * -1)))
        let endAngle = Angle.degrees(180 * (1 - (endPosition * -1)))
        
        path.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: false
        )
        
        return path
    }
}
