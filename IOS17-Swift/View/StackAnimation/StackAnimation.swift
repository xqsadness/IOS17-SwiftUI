//
//  StackAnimation.swift
//  IOS17-Swift
//
//  Created by xqsadness on 1/10/24.
//

import SwiftUI

struct StackAnimation: View {
    var body: some View {
        ScrollView{
            VStack(spacing: 15){
                StackView(Tcolor: .purple, color: .cyan, icon: "book", title: "Read Books")
                
                StackView(Tcolor: .blue.opacity(0.7), color: .cyan, icon: "movieclapper", title: "Movies")
            }
        }
    }
}

#Preview {
    StackAnimation()
}
