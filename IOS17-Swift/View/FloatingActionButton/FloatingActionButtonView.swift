//
//  FloatingActionButton.swift
//  IOS17-Swift
//
//  Created by iamblue on 08/04/2024.
//

import SwiftUI

struct FloatingActionButton: View {
    @State private var colors: [Color] = [Color.red, Color.yellow, Color.blue, Color.gray, Color.black, Color.pink, Color.cyan, Color.purple, Color.green]
    var body: some View {
        ScrollView(.vertical){
            LazyVStack{
                ForEach(colors, id: \.self){ color in
                    RoundedRectangle(cornerRadius: 15)
                        .fill(color.gradient)
                        .frame(height: 200)
                }
            }
            .padding(15)
        }
        .overlay(alignment: .bottomTrailing){
            FloatingButton {
                FloatingAction(symbol: "tray.full.fill") {
                    print("tray")
                }
                FloatingAction(symbol: "lasso.badge.sparkles") {
                    print("lasso")
                }
                FloatingAction(symbol: "square.and.arrow.up.fill") {
                    print("square")
                }
            } label: { isExpanded in
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .rotationEffect(.init(degrees: isExpanded ? 45 : 0))
                    .scaleEffect(1.02)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(.black, in: .circle)
                //scaling effect when expanded
                    .scaleEffect(isExpanded ? 0.9 : 1)
            }
            .padding()
        }
    }
}

#Preview {
    FloatingActionButton()
}
