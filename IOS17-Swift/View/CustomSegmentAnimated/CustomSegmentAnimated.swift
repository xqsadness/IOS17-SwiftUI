//
//  CustomSegment.swift
//  IOS17-Swift
//
//  Created by xqsadness on 11/06/2024.
//

import SwiftUI

//MARK: This view is for testing purposes only, do not use it !!!
struct SegmentAnimatedView: View {
    @State private var isVideo: Bool = false
    var body: some View {
        CustomSegmentAnimated(isSelected: $isVideo, text1: "Song", text2: "Video")
            .frame(width: 180)
    }
}

struct CustomSegmentAnimated: View {
    @Binding var isSelected: Bool
    @State private var shakeValue: CGFloat = 0
    
    var text1: String = "text1"
    var text2: String = "text2"
    
    var body: some View {
        HStack(spacing: 0) {
            TabableText(title: "\(text1)")
                .foregroundColor(.accentColor)
                .overlay {
                    Rectangle()
                        .fill(Color.accentColor)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 30,
                                bottomLeadingRadius: 30,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 0
                            )
                        )
                        .overlay {
                            TabableText(title: "\(text2)")
                                .foregroundColor(isSelected ? .white : .clear)
                                .scaleEffect(x: -1)
                        }
                        .rotation3DEffect(.init(degrees: isSelected ? 180 : 0), axis: (x: 0, y: 1, z: 0), anchor: .trailing, perspective: 0.4)
                }
                .overlay(content: {
                    TabableText(title: "\(text1)")
                        .foregroundColor(isSelected ? .clear : .white)
                })
                .zIndex(1)
                .contentShape(Rectangle())
                .shadow(color: Color.white.opacity(0.4), radius: 3, x: 0, y: 1)
            
            TabableText(title: "\(text2)")
                .foregroundColor(.accentColor)
                .zIndex(0)
                .shadow(color: Color.green.opacity(0.4), radius: 3, x: 0, y: 1)
            
        }
        .background {
            ZStack {
                Capsule().fill(Color.white)
                Capsule().stroke(Color.accentColor, lineWidth: 3)
            }
        }
        .rotation3DEffect(.init(degrees: shakeValue), axis: (x: 0, y: 1, z: 0))
    }
    
    private func TabableText(title: String) -> some View {
        Text(title)
            .font(Font.system(size: 14))
            .padding(.vertical, 5)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity)
            .contentShape(Rectangle())
            .onTapGesture {
                withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                    self.isSelected = (title == "\(text2)")
                    
                    self.shakeValue = (title == "\(text2)" ? 10 : -10)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation(.interactiveSpring(response: 0.4, dampingFraction: 1, blendDuration: 1)) {
                            self.shakeValue = 0
                        }
                    }
                }
            }
    }
}
