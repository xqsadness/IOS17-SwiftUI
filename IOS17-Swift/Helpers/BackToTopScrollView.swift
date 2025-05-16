//
//  BackToTopScrollView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 16/5/25.
//

import SwiftUI

struct BackToTopScrollView<Content: View, ButtonView: View>: View {
    private let contentView: (ScrollViewProxy) -> Content
    private let buttonView: () -> ButtonView
    private var buttonPosition: Alignment = .top
    private var invisibleTopViewId: String = "TOP_ID"
    private var coordinateSpaceName: String = "BACK_TO_TOP_SCROLLVIEW"
    private var minimumScrollOffset: CGFloat = 20
    private var buttonTransition: AnyTransition = .identity
    @State private var offset: CGPoint = .zero
    @State private var showBackButton: Bool = false
    
    init(
        @ViewBuilder contentView: @escaping(ScrollViewProxy) -> Content,
        @ViewBuilder buttonView: @escaping () -> ButtonView
    ) {
        self.contentView = contentView
        self.buttonView = buttonView
    }
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                Color.clear
                    .frame(height: 0)
                    .id(invisibleTopViewId)
                
                PositionObservingView(
                    coordinateSpace: .named(coordinateSpaceName),
                    position: Binding(
                        get: { offset },
                        set: { newOffset in
                            offset = CGPoint(
                                x: -newOffset.x,
                                y: -newOffset.y
                            )
                        }
                    ),
                    content: {
                        contentView(scrollProxy)
                    }
                )
            }
            .coordinateSpace(name: coordinateSpaceName)
            .overlay(alignment: buttonPosition) {
                if showBackButton {
                    Button {
                        withAnimation { scrollProxy.scrollTo(invisibleTopViewId) }
                    } label: {
                        buttonView()
                    }
                    .transition(buttonTransition)
                    .buttonStyle(ButtonPressStyle())
                }
            }
        }
        .onChange(of: offset.y) { _,newValue in
            withAnimation(.easeInOut) {
                if newValue > minimumScrollOffset && !showBackButton {
                    showBackButton = true
                } else if newValue < minimumScrollOffset && showBackButton {
                    showBackButton = false
                }
            }
        }
    }
    
    struct ButtonPressStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.8 : 1)
                .animation(.linear, value: configuration.isPressed)
        }
    }
}

extension BackToTopScrollView {
    func buttonPosition(_ position: Alignment) -> Self {
        var view = self
        view.buttonPosition = position
        return view
    }
    
    func minimumScrollOffset(_ value: CGFloat) -> Self {
        var view = self
        view.minimumScrollOffset = value
        return view
    }
    
    func buttonTransition(_ value: AnyTransition) -> Self {
        var view = self
        view.buttonTransition = value
        return view
    }
}

struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace).origin
                )
            })
            .onPreferenceChange(PreferenceKey.self) { position in
                self.position = position
            }
    }
}

private extension PositionObservingView {
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGPoint { .zero }
        
        static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
            // No-op
        }
    }
}
