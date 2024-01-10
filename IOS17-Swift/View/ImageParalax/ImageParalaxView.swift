//
//  ImageParalaxView.swift
//  IOS17-Swift
//
//  Created by xasadness on 10/01/2024.
//

import SwiftUI

struct ImageParalaxView: View {
    @State var valueTranslation: CGSize = .zero
    @State var isDragging = false
    
    var body: some View {
        ZStack{
            Image(.stars)
                .resizable()
                .scaledToFill()
                .frame(width: 250, height: 550)
                .offset(x: valueTranslation.width / 10, y: valueTranslation.height / 10)
            
            Image(.planet)
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .offset(x: valueTranslation.width / 5, y: valueTranslation.height / 5)
            
            Circle()
                .frame(width: 60, height: 60)
                .blur(radius: 50)
                .offset(x: valueTranslation.width / 1.5, y: valueTranslation.height / 1.5)
        }
        .offset(x: valueTranslation.width / 10, y: valueTranslation.height / 10)
        .frame(width: 300, height: 400)
        .background(Color(hex: "161228"))
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .rotation3DEffect(
            .degrees(isDragging ? 10 : 0),
            axis: (x: -valueTranslation.height, y: valueTranslation.width, z: 0.0)
        )
        .gesture(DragGesture()
            .onChanged({ value in
                withAnimation {
                    valueTranslation = value.translation
                    isDragging = true
                }
            })
                .onEnded({ value in
                    withAnimation {
                        valueTranslation = .zero
                        isDragging = false
                    }
                })
        )
    }
}

#Preview {
    ImageParalaxView()
}
