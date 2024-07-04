//
//  FlipClockTextEffectView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 17/06/2024.
//

import SwiftUI

struct FlipClockTextEffectView: View {
    @State private var timer: CGFloat = 60
    @State private var count: Int = 60
    @State private var timerRunning: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 4) {
                    FlipClockTextEffect(
                        value: .constant(count / 10),
                        size: CGSize(width: 100, height: 150),
                        fontSize: 70,
                        cornerRadius: 10,
                        foreground: .white,
                        background: .red
                    )
                    
                    FlipClockTextEffect(
                        value: .constant(count % 10),
                        size: CGSize(width: 100, height: 150),
                        fontSize: 70,
                        cornerRadius: 10,
                        foreground: .white,
                        background: .red
                    )
                }
                .onReceive(Timer.publish(every: 0.01, on: .current, in: .common).autoconnect()) { _ in
                    guard timerRunning else { return }
                    
                    timer -= 0.01
                    if timer <= 0 {
                        timer = 0
                        timerRunning = false
                    }
                    count = Int(timer)
                }
            }
            .padding()
        }
    }
}

struct FlipClockTextEffect: View {
    
    @Binding var value: Int
    //Config
    var size: CGSize
    var fontSize: CGFloat
    var cornerRadius: CGFloat
    var foreground: Color
    var background: Color
    var animationDuration: CGFloat = 0.8
    //view props
    @State private var nextValue: Int = 0
    @State private var currentValue: Int = 0
    @State private var rotation: CGFloat = 0
    
    var body: some View {
        let halfHeight = size.height * 0.5
        
        ZStack{
            UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
                .fill(background.shadow(.inner(radius: 0)))
                .frame(height: halfHeight)
                .overlay(alignment: .top){
                    TextView(nextValue)
                        .frame(width: size.width, height: size.height)
                        .drawingGroup()
                }
                .clipped()
                .frame(maxHeight: .infinity, alignment: .top)
            
            UnevenRoundedRectangle(topLeadingRadius: cornerRadius, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: cornerRadius)
                .fill(background.shadow(.inner(radius: 0)))
                .frame(height: halfHeight)
                .modifier(
                    RotationModifier(
                        rotation: rotation,
                        currentValue: currentValue,
                        nextValue: nextValue,
                        fontSize: fontSize,
                        foreground: foreground,
                        size: size
                    )
                )
                .clipped()
                .rotation3DEffect(
                    .init(degrees: rotation),
                    axis:(
                        x: 1.0,
                        y: 0.0,
                        z: 0.0
                    ),
                    anchor: .bottom,
                    anchorZ: 0,
                    perspective: 0.4
                )
                .frame(maxHeight: .infinity, alignment: .top)
                .zIndex(10)
            
            UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: cornerRadius, bottomTrailingRadius: cornerRadius, topTrailingRadius: 0)
                .fill(background.shadow(.inner(radius: 1)))
                .frame(height: halfHeight)
                .overlay(alignment: .bottom){
                    TextView(currentValue)
                        .frame(width: size.width, height: size.height)
                        .drawingGroup()
                }
                .clipped()
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(width: size.width, height: size.height)
        .onChange(of: value, initial: true){ old, new in
            currentValue = old
            nextValue = new
            
            guard rotation == 0 else{
                currentValue = new
                return
            }
            
            guard old != new else { return }
            
            withAnimation(.easeInOut(duration: animationDuration), completionCriteria: .logicallyComplete) {
                rotation = -180
            }completion: {
                rotation = 0
                currentValue = value
            }
        }
    }
    
    //Reusable view
    @ViewBuilder
    func TextView(_ value: Int) -> some View{
        Text("\(value)")
            .font(.system(size: fontSize).bold())
            .foregroundStyle(foreground)
            .lineLimit(1)
    }
}

fileprivate struct RotationModifier: ViewModifier, Animatable {
    var rotation: CGFloat
    var currentValue: Int
    var nextValue: Int
    var fontSize: CGFloat
    var foreground: Color
    var size: CGSize
    var animatableData: CGFloat {
        get { rotation }
        set { rotation = newValue }
    }
    func body (content: Content) -> some View {
        content
            .overlay (alignment: .top) {
                Group{
                    if -rotation > 90 {
                        Text("\(nextValue)")
                            .font(.system (size: fontSize).bold())
                            .foregroundStyle (foreground)
                            .scaleEffect(x: 1, y: -1)
                            .transition(.identity)
                            .lineLimit(1)
                    } else {
                        Text("\(currentValue)")
                            .font(.system (size: fontSize).bold())
                            .foregroundStyle (foreground)
                            .transition(.identity)
                            .lineLimit(1)
                    }
                }
                .frame(width: size.width, height: size.height)
                .drawingGroup()
            }
    }
}

#Preview {
    FlipClockTextEffectView()
}
