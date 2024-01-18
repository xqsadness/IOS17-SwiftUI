//
//  CoverFlowView.swift
//  IOS17-Swift
//
//  Created by iamblue on 18/01/2024.
//

import SwiftUI

struct CoverFlowShowView: View {
    
    @State private var items: [CoverFlowItem] = [.red, .blue, .green, .yellow, .primary, .cyan]
        .compactMap{ return .init(color: $0) }
    // view props
    @State private var spacing: CGFloat = 0
    @State private var rotation: CGFloat = .zero
    @State private var enableReflection: Bool = false
    
    var body: some View {
        VStack{
            Spacer(minLength: 0)
            
            CoverFlowView(
                itemWidth: 280,
                enableReflection: enableReflection,
                spacing: spacing,
                rotation: rotation,
                items: items) { item in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(item.color.gradient)
                }
                .frame(height: 180)
            
            Spacer(minLength: 0)
            
            //Custom view
            
            VStack(alignment: .leading, spacing: 10){
                Toggle("Toggle Reflection", isOn: $enableReflection)
                
                Text("Card Spacing")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                Slider(value: $spacing, in: -120...20)
                
                Text("Card Rotation")
                    .font(.caption2)
                    .foregroundStyle(.gray)
                
                Slider(value: $rotation, in: 0...180)
            }
            .padding(15)
            .background(.ultraThinMaterial, in: .rect(cornerRadius: 20))
            .padding(15)
        }
    }
}

#Preview{
    CoverFlowShowView()
}
