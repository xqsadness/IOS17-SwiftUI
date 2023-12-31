//
//  ScrollTransition.swift
//  IOS17-Swift
//
//  Created by xqsadness on 30/11/2023.
//

import SwiftUI

struct ScrollTransitionsView: View {
    var body: some View {
        ScrollView(.vertical){
            LazyVStack{
                ForEach(1...30, id: \.self){ _ in
                    Rectangle()
                        .fill(.red.gradient)
                        .frame(height: 145)
                        .scrollTransition(topLeading: .interactive, bottomTrailing: .interactive) { view, phase in view
                                .opacity(1 - ( phase.value < 0 ? -phase.value : phase.value))
                                .scaleEffect(phase.isIdentity ? 1 : 0.75)
                                .blur(radius: phase.isIdentity ? 0 : 10)
                        }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ScrollTransitionsView()
}
