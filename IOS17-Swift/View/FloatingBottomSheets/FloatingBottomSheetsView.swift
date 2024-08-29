//
//  FloatingBottomSheetsView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 29/8/24.
//

import SwiftUI

struct FloatingBottomSheetsView: View {
    //View props
    @State private var showSheet: Bool = false
    var body: some View {
        NavigationStack{
            VStack{
                Button("Show sheet"){
                    showSheet.toggle()
                }
            }
            .navigationTitle("Floating bottom sheet")
        }
        .floatingBottomSheet(isPresented: $showSheet) {
            SheetView(
                title: "Replace Existing Folder?",
                content: "Lorem Ipsum is simply dummy text of the printing and typesetting industry .",
                image: .init(
                    content: "questionmark.folder.fill",
                    tint: .blue,
                    foreground: .white
                ),
                button1: .init(
                    content: "Replace",
                    tint: .blue,
                    foreground: .white
                ),
                button2: .init(
                    content: "Cancel",
                    tint: Color.primary.opacity(0.08),
                    foreground: Color.primary
                )
            )
            .presentationDetents ([.height(330)])
        }
    }
}

#Preview {
    FloatingBottomSheetsView()
}

/// Sample View
struct SheetView: View {
    var title: String
    var content: String
    var image: Config
    var button1: Config
    var button2: Config?
    var body: some View {
        VStack(spacing: 15) {
            Image(systemName: image.content)
                .font(.title)
                .foregroundStyle(image.foreground)
                .frame(width: 65, height: 65)
                .background(image.tint.gradient, in: .circle)
            
            Text(title)
                .font(.title3.bold())
            
            Text (content)
                .font(.callout)
                .multilineTextAlignment (.center)
                .lineLimit(2)
                .foregroundStyle(.gray)
            
            ButtonView(button1)
            
            if let button2{
                ButtonView(button2)
            }
        }
        .padding([.horizontal, .bottom], 15)
        .background{
            RoundedRectangle(cornerRadius: 15)
                .fill(.background)
                .padding(.top, 30)
        }
        .shadow(color: .black.opacity(0.12) ,radius: 8)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    func ButtonView(_ config: Config) -> some View{
        Button{
            
        }label: {
            Text(config.content)
                .fontWeight(.bold)
                .foregroundStyle(config.foreground)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(config.tint.gradient, in: .rect(cornerRadius: 10))
        }
    }
    
    struct Config {
        var content: String
        var tint: Color
        var foreground: Color
    }
}
