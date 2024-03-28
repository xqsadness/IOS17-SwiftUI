//
//  SideMenuView.swift
//  IOS17-Swift
//
//  Created by iamblue on 28/03/2024.
//

import SwiftUI

struct AnimatedSideBar<Content: View, MenuView: View, Background: View>: View {
    var rotationsWhenExpands: Bool = true
    var disableInteraction: Bool = true
    var sideMenuWidth: CGFloat = 200
    var connerRadius: CGFloat = 25
    @Binding var showMenu: Bool
    
    @ViewBuilder var content: (UIEdgeInsets) -> Content
    @ViewBuilder var menuView: (UIEdgeInsets) -> MenuView
    @ViewBuilder var background: Background
    
    @GestureState var isDragging = false
    @State var offsetX: CGFloat = 0
    @State var lastOffsetX: CGFloat = 0
    @State var progress: CGFloat = 0
    
    var body: some View {
        GeometryReader{
            let size = $0.size
            let safeArea = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.safeAreaInsets ?? .zero
            
            HStack(spacing: 0){
                GeometryReader{_ in
                    menuView(safeArea)
                }
                .frame(width: sideMenuWidth)
                
                GeometryReader{_ in
                    content(safeArea)
                }
                .frame(width: size.width)
                .overlay{
                    if disableInteraction && progress > 0{
                        Rectangle()
                            .fill(.black.opacity(progress * 0.2))
                            .onTapGesture {
                                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                                    reset()
                                }
                            }
                    }
                }
                .mask {
                    RoundedRectangle(cornerRadius: progress * connerRadius)
                }
                .scaleEffect(rotationsWhenExpands ? 1 - (progress * 0.1) : 1, anchor: .trailing)
                .rotation3DEffect(
                    .init(degrees: rotationsWhenExpands ? (progress * -15) : 0),
                    axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            }
            .frame(width: size.width + sideMenuWidth, height: size.height)
            .offset(x: -sideMenuWidth)
            .offset(x: offsetX)
            .contentShape(.rect)
            .simultaneousGesture(dragGesture)
        }
        .background(background)
        .ignoresSafeArea()
        .onChange(of: showMenu, initial: true) { oldValue, newValue in
            withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                if newValue{
                    showSideBar()
                }
                else{
                    reset()
                }
            }
        }
    }
    
    var dragGesture : some Gesture {
        DragGesture()
            .updating($isDragging) { _, out, _ in
                out = true
            }
            .onChanged { value in
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    guard value.startLocation.x > 10 else {return}
                    
                    let translationX = isDragging ? max(min(value.translation.width + lastOffsetX, sideMenuWidth), 0) : 0
                    
                    offsetX = translationX
                    calculateProgress()
                }
            }
            .onEnded { value in
                guard value.startLocation.x > 10 else {return}
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    let velocityX = value.velocity.width / 8
                    let total = velocityX + offsetX
                    
                    if total > (sideMenuWidth * 0.5){
                        showSideBar()
                    }
                    else{
                        reset()
                    }
                }
            }
    }
    
    func showSideBar(){
        offsetX = sideMenuWidth
        lastOffsetX = offsetX
        showMenu = true
        calculateProgress()
    }
    
    func reset(){
        offsetX = 0
        lastOffsetX = 0
        showMenu = false
        calculateProgress()
    }
    
    func calculateProgress(){
        progress = max(min(offsetX / sideMenuWidth , 1) ,0)
    }
}
