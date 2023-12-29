//
//  ParallaxScrollEffectView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 29/12/2023.
//

import SwiftUI

struct ParallaxScrollEffectView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            LazyVStack(spacing: 15){
                DummySection(title: "Social Media")
                
                DummySection(title: "Sales", isLong: true)
                
                //Parallax Image
                ParallaxImage(usesFullWidth: true){ size in
                    Image(.p1)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 300)
                
                DummySection(title: "Busniess", isLong: true)
                
                DummySection(title: "Promotion", isLong: true)
                
                ParallaxImage(maximumMovement: 150,usesFullWidth: false){ size in
                    Image(.p2)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width, height: size.height)
                }
                .frame(height: 400)
                
                DummySection(title: "Youtube")
                
                DummySection(title: "Meta")
            }
            .padding(15)
        }
    }
    
    // Dummy Section
    @ViewBuilder
    func DummySection(title: String, isLong: Bool = false) -> some View{
        VStack(alignment: .leading, spacing: 8){
            Text(title)
                .font(.title.bold())
            
            Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum")
                .multilineTextAlignment(.leading)
                .kerning(1.2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ParallaxImage<Content: View>: View{
    var maximumMovement: CGFloat = 100
    var usesFullWidth: Bool = false
    
    @ViewBuilder var content: (CGSize) -> Content
    
    var body: some View{
        GeometryReader{
            let size = $0.size
            // Movement animation props
            let minY = $0.frame(in: .scrollView(axis: .vertical)).minY
            let scrollViewHeight = $0 .bounds(of: .scrollView)?.size.height ?? 0
            let maximumMovement = min(maximumMovement, (size.height * 0.35))
            let stretchedSize: CGSize = .init(width: size.width, height: size.height + maximumMovement)
            
            let progress = minY / scrollViewHeight
            let cappedProgress = max(min(progress, 1.0), 0.0)
            let movementOffset = cappedProgress * -maximumMovement
            
            content(size)
                .offset(y: movementOffset)
                .frame(width: stretchedSize.width, height: stretchedSize.height)
                .frame(width: size.width, height: size.height)
                .overlay(alignment: .top){
                    Text("\(cappedProgress)")
                        .font(.title)
                        .foregroundStyle(.white)
                }
                .clipped()
        }
        .containerRelativeFrame(usesFullWidth ? [.horizontal] : [])
    }
}

#Preview {
    ParallaxScrollEffectView()
}
