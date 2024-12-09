//
//  PatternLockScreen.swift
//  IOS17-Swift
//
//  Created by xqsadness on 9/12/24.
//

import SwiftUI

struct PatternLockScreen: View {
    @State private var isUnlocked: Bool = false // State to track if the pattern is unlocked
    
    var body: some View {
        VStack {
            MainView() // Main home view shown when unlocked
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .overlay {
            if !isUnlocked {
                GeometryReader { _ in
                    // Black overlay to hide the main content until unlocked
                    Rectangle()
                        .fill(.black)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 25) {
                        // Instruction text to prompt the user to unlock
                        Text("Draw the Pattern to Unlock")
                            .font(.largeTitle)
                            .fontWidth(.condensed)
                            .foregroundColor(.white)
                        
                         //Pattern input view for drawing the unlocking pattern
                        PatternInputView(
                            outerCircleColor: .black,
                            lineColor: .white,
                            skipVerification: false,
                            requiredPattern: [
                                .three,
                                .two,
                                .one,
                                .four,
                                .five,
                                .six,
                                .nine,
                                .eight,
                                .seven
                            ].compactMap { $0 }
                        ) { status, pattern in
                            withAnimation(.spring(response: 0.45)) {
                                isUnlocked = status // Update unlock status based on pattern input
                            }
                        }
                        
                        // Button to reset pattern in case the user forgets it
                        Button(action: resetPattern, label: {
                            Text("Forgot Pattern?")
                                .font(.callout)
                                .foregroundColor(.gray)
                        })
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(35)
                    }
                    .frame(maxHeight: .infinity)
                }
                .transition(.slide)
            }
        }
    }
    
    func resetPattern() {
        // Logic to reset the pattern
    }
}

// Main view displayed when the pattern is unlocked
struct MainView: View {
    var body: some View {
        Text("Welcome to the Home View")
            .navigationTitle("Main Screen")
    }
}

// Custom pattern input view to handle pattern unlocking
struct PatternInputView: View {
    // Configuration properties
    var outerCircleColor: Color = .white // Outer circle color of each pattern dot
    var lineColor: Color = .green // Line color for the drawn pattern
    var skipVerification: Bool = false // Flag to disable pattern verification
    var requiredPattern: [PatternSymbol] = [] // Required pattern to unlock
    var onPatternComplete: (Bool, [PatternSymbol]) -> () // Completion handler for pattern input
    
    // View properties
    @State private var availableDots: [PatternNode] = (1...9).compactMap({ return PatternNode(number: $0) }) // All pattern dots
    @State private var currentDragLocation: CGPoint = .zero // Current dragging location
    @State private var activePattern: [PatternNode] = [] // Connected dots in the active pattern
    @State private var displayError: Bool = false // Trigger to display incorrect pattern animation
    
    var body: some View {
        // Pattern grid view to show all the dots
        PatternGridView()
            .background{
                // Define line path for the drawn pattern
                let points = activePattern.map {
                    let frame = $0.dotFrame
                    return CGPoint(x: frame.midX, y: frame.midY)
                }
                
                ZStack {
                    if !points.isEmpty {
                        PatternDrawingPath(points: points, currentLocation: currentDragLocation)
                            .stroke(
                                displayError ? .red : lineColor, // Red color if the pattern is incorrect
                                style: StrokeStyle(
                                    lineWidth: 10,
                                    lineCap: .round,
                                    lineJoin: .round
                                )
                            )
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut(duration: 0.4), value: points)
            }
            .shakeEffect(trigger: displayError, distance: 20)
    }
    
    @ViewBuilder
    private func PatternGridView() -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0) {
            ForEach($availableDots) { $dot in
                GeometryReader { geometry in
                    let frame = geometry.frame(in: .named("PATTERN_GRID"))
                    Circle()
                        .fill(outerCircleColor)
                        .frame(width: 35, height: 35)
                        .overlay(
                            Circle()
                                .fill(displayError ? .red : lineColor)
                                .frame(width: 20, height: 20)
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .preference(key: DotFrameKey.self, value: frame) // Set dot frame for touch detection
                        .onPreferenceChange(DotFrameKey.self) { dot.dotFrame = $0 }
                }
                .padding(.horizontal, 15) // Padding for touch sensitivity
                .frame(height: 100)
            }
        }
        .frame(height: 300)
        .frame(maxWidth: 400)
        .padding(.horizontal, 20)
        .coordinateSpace(name: "PATTERN_GRID")
        .animation(.easeOut(duration: 0.4), value: displayError)
        .contentShape(.rect)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { gesture in
                    let location = gesture.location
                    // Add dot to pattern if touched and not already in pattern
                    if let dot = availableDots.first(where: { $0.dotFrame.contains(location) }),
                       !activePattern.contains(where: { $0.id == dot.id }) {
                        activePattern.append(dot)
                    }
                    currentDragLocation = location // Update drag location
                }
                .onEnded { gesture in
                    currentDragLocation = .zero
                    guard !activePattern.isEmpty else { return }
                    let enteredPattern = activePattern.map({ PatternSymbol(rawValue: $0.number) }).compactMap { $0 }
                    // Pattern verification or bypass based on configuration
                    if skipVerification {
                        activePattern = []
                        onPatternComplete(false, enteredPattern) // Successful pattern entry
                    } else {
                        if enteredPattern == requiredPattern {
                            activePattern = []
                            onPatternComplete(true, enteredPattern) // Successful pattern entry
                        } else {
                            withAnimation(.easeInOut(duration: 0.4)) {
                                displayError = true // Trigger error animation
                            }
                            completion: {
                                displayError = false
                                activePattern = []
                                onPatternComplete(false, enteredPattern) // Failed pattern entry
                            }
                        }
                    }
                }
        )
        .disabled(displayError) // Disable gestures during error animation
    }
    
    // Represents each dot in the pattern grid
    private struct PatternNode: Identifiable {
        let id: UUID = UUID() // Unique identifier for each dot
        var number: Int // Dot number
        var dotFrame: CGRect = .zero // Dot frame for touch detection
    }

    // DotFrameKey stores each dot's frame for use in preference key
    private struct DotFrameKey: PreferenceKey {
        static var defaultValue: CGRect = .zero
        static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
            value = nextValue()
        }
    }

    // Shape that draws the pattern path based on touch points
    private struct PatternDrawingPath: Shape {
        var points: [CGPoint] // Points of the connected pattern
        var currentLocation: CGPoint // Current drag location for extending the path

        func path(in rect: CGRect) -> Path {
            var path = Path()
            for (index, point) in points.enumerated() {
                if index == 0 {
                    path.move(to: point)
                } else {
                    path.addLine(to: point)
                }
            }
            if currentLocation != .zero {
                path.addLine(to: currentLocation)
            }
            return path
        }
    }

    // Enum representing the numbers in the pattern (1-9)
    enum PatternSymbol: Int {
        case one = 1, two, three, four, five, six, seven, eight, nine
    }
}

extension View {
    // Custom shake effect for incorrect patterns
    func shakeEffect(trigger: Bool, distance: CGFloat) -> some View {
        return self.modifier(ShakeEffect(trigger: trigger, distance: distance))
    }
}

// Shake effect modifier
struct ShakeEffect: AnimatableModifier {
    var trigger: Bool // Trigger to activate shake
    var distance: CGFloat // Shake distance
    var animatableData: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(x: sin(animatableData * .pi * 2) * distance) // Shake offset calculation
            .animation(trigger ? Animation.easeOut(duration: 0.2).repeatCount(3) : nil, value: trigger)
    }
}

