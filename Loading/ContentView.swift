//
//  ContentView.swift
//  Loading
//
//  Created by HEssam on 12/26/24.
//

import SwiftUI

struct ContentView: View {
    
    // Animation-related states
    @State private var completionFraction = 0.0
    @State private var isAnimatingForward = true
    
    // Offset states for circles
    @State private var arcOffsetX: CGFloat = 0
    @State private var redCircleOffset: CGFloat = 0
    @State private var yellowCircleOffset: CGFloat = 0
    
    // Opacity for the red circle
    @State private var redCircleOpacity: Double = 1.0
    
    //
    private var easeInOutAnimation: Animation {
        .easeInOut(duration: 1.0)
    }
    
    private var springAnimation: Animation {
        .spring(duration: 0.25)
    }
    
    var body: some View {
        ZStack {
            Color(.background)
                .ignoresSafeArea()
            
            ZStack {
                Color(.background)
                    .ignoresSafeArea()
                
                ArcShape(
                    fromPosition: isAnimatingForward ? 0 : completionFraction,
                    endPosition: isAnimatingForward ? completionFraction : 1.0)
                .stroke(Color.arc, style: StrokeStyle(
                    lineWidth: 10,
                    lineCap: .round,
                    lineJoin: .bevel
                )
                )
                .frame(width: 100, height: 100)
                
                Circle()
                    .fill(Color.arc)
                    .frame(width: 10)
                    .offset(x: -50, y: 50)
                    .opacity(redCircleOpacity)
                    .offset(x: redCircleOffset)
                
                Circle()
                    .fill(Color.target)
                    .frame(width: 10)
                    .offset(x: 50, y: 50)
                    .offset(x: yellowCircleOffset)
            }
            .offset(x: arcOffsetX)
            
        }
        .onAppear {
            startPeriodicAnimation(
                animationStep: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                        withAnimation(springAnimation) {
                            yellowCircleOffset = 100
                        }
                    }
                    completionFraction = 1.0
                    arcOffsetX = -50
                    redCircleOpacity = 0
                    
                }, midwayChangesWithoutAnimation: {
                    redCircleOffset = 100
                    redCircleOpacity = 1
                }, midwayCompletion: {
                    isAnimatingForward.toggle()
                    arcOffsetX = -100
                }, fullCycleCompletion: {
                    yellowCircleOffset = 0
                    redCircleOffset = 0
                    arcOffsetX = 0
                    isAnimatingForward = true
                    completionFraction = 0
                })
        }
    }
    
    private func startPeriodicAnimation(
        animationStep: @escaping () -> Void,
        midwayChangesWithoutAnimation: @escaping () -> Void,
        midwayCompletion: @escaping () -> Void,
        fullCycleCompletion: @escaping () -> Void
    ) {
        withAnimation(easeInOutAnimation) {
            animationStep()
            
        } completion: {
            midwayChangesWithoutAnimation()
            withAnimation(easeInOutAnimation) {
                midwayCompletion()
            } completion: {
                fullCycleCompletion()
                
                startPeriodicAnimation(
                    animationStep: animationStep,
                    midwayChangesWithoutAnimation: midwayChangesWithoutAnimation,
                    midwayCompletion: midwayCompletion,
                    fullCycleCompletion: fullCycleCompletion
                )
            }
        }
    }
}

#Preview {
    ContentView()
}
