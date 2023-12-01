//
//  AnimatedSFSymbol.swift
//  IOS17-Swift
//
//  Created by darktech4 on 30/11/2023.
//

import SwiftUI

struct AnimatedSFSymbol: View {
    @State private var animateSymbol: Bool = false
    var body: some View {
       Image(systemName: "suit.heart.fill")
            .font(.largeTitle)
            .tint(.red)
            .symbolEffect(.bounce,options: .default ,value: animateSymbol)
            .onTapGesture {
                animateSymbol.toggle()
            }
    }
}

#Preview {
    AnimatedSFSymbol()
}
