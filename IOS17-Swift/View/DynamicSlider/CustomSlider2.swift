//
//  CustomSlider.swift
//  IOS17-Swift
//
//  Created by xqsadness on 13/06/2024.
//

import SwiftUI

struct CustomSlider2: View {
    
    let width: CGFloat
    let height: CGFloat
    //horizontal slider or vertical
    let axis: Axis
    @Binding var thevalue: Double
    @State private var dragging: CGFloat = 0
    @State private var startDragging: CGFloat = 0
    
    var body: some View {
        ZStack{
            Capsule()
                .frame(width: width, height: height)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: axis == .horizontal ? .leading : .bottom)
                .foregroundStyle(.thinMaterial)
            Capsule()
                .frame(width: axis == .horizontal ? max(0, dragging + height) : width, height: axis == .vertical ? max(0, -dragging + width) : height)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: axis == .horizontal ? .leading : .bottom)
                .foregroundStyle(LinearGradient(gradient: Gradient(colors: gradientColors()), startPoint: axis == .horizontal ? .leading : .bottom, endPoint: axis == .horizontal ? .trailing : .top))
        }
        .frame(width: width, height: height)
        .overlay(alignment: axis == .horizontal ? .leading : .bottom){
            Circle()
                .frame(width: axis == .horizontal ? height : width, height: axis == .vertical ? width : height)
                .foregroundStyle(.white)
                .offset(x: axis == .horizontal ? dragging : 0, y: axis == .vertical ? dragging : 0)
                .gesture(
                    DragGesture()
                        .onChanged{ ges in
                            updateDragging(gesture: ges)
                            thevalue = axis == .horizontal ? Double(dragging / maxDragDistance()) : Double(-dragging / maxDragDistance())
                        }
                        .onEnded{ _ in
                            startDragging = dragging
                        }
                )
        }
        .overlay {
            Text("\(thevalue)")
                .frame(width: 100)
                .offset(x: 100)
        }
    }
    
    private func updateDragging(gesture: DragGesture.Value){
        if axis == .horizontal{
            let newValue = startDragging + gesture.translation.width
            dragging = newValue <= 0 ? 0 : min(newValue, maxDragDistance())
        }else{
            let newValue = startDragging + gesture.translation.height
            dragging = newValue >= 0 ? 0 : max(newValue, -maxDragDistance())
        }
    }
    
    private func maxDragDistance() -> CGFloat{
        return axis == .horizontal ? width - height : height - width
    }
    
    private func gradientColors() -> [Color]{
        let progress = axis == .horizontal ? min(max(dragging / maxDragDistance(), 0), 1) : min(max(-dragging / maxDragDistance(), 0), 1)
        let topColor = Color(red: progress, green: 1.0, blue: 1.0 - progress)
        let botttomColor = Color(red: progress, green: progress * 0.4, blue: 1.0 - progress)
        return [botttomColor, topColor]
    }
}

#Preview {
    CustomSlider2(width: 50, height: 300, axis: .vertical, thevalue: .constant(0.5))
}
