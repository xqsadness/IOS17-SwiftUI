//
//  DropDownView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 14/11/24.
//

import SwiftUI

struct DropDown: View {
    
    @State private var selection: String?
    @State private var selection2: String?
    
    var body: some View {
        ScrollView{
            VStack(spacing: 15){
                DropDownView(
                    hint: "Movies",
                    options: ["Batman", "Superman", "Spider-Man", "Wonder Woman", "Aquaman", "Black Panther"],
                    anchor: .bottom,
                    height: 40,
                    selection: $selection
                )
                
                DropDownView(
                    hint: "Artists",
                    options: ["Joji","The weeknd", "Billie Eilish", "Taylor Swift"],
                    anchor: .bottom,
                    height: 40,
                    selection: $selection2
                )
            }
            .padding(.horizontal)
            .padding(.top, 50)
        }
    }
}

struct DropDownView: View {
    /// Customization Properties
    var hint: String
    var options: [String]
    var anchor: Anchor = .bottom
    var height: CGFloat = 50
    var cornerRadius: CGFloat = 10
    @Binding var selection: String?
    //view props
    @State private var showOptions: Bool = false
    @Environment(\.colorScheme) private var scheme
    @SceneStorage("drop_down_zindex") private var index = 1000.0
    @State private var zIndex: Double = 1000.0
    var body: some View {
        GeometryReader { geometry in
            let size = geometry.size
            
            VStack(spacing: 0){
                if showOptions && anchor == .top{
                    OptionsView()
                }
                
                HStack(spacing: 0) {
                    if let selection = selection{
                        Text(selection)
                            .foregroundStyle(.primary)
                            .font(.callout)
                            .lineLimit(1)
                    }else{
                        Text(hint)
                            .foregroundStyle(.gray)
                            .font(.callout)
                            .lineLimit(1)
                    }
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "chevron.down")
                        .imageScale(.medium)
                        .foregroundStyle(.gray)
                        .rotationEffect(.init(degrees: showOptions ? -180 : 0))
                }
                .padding(.horizontal, 15)
                .frame(width: size.width, height: size.height)
                .background(scheme == .dark ? .black : .white)
                .contentShape(.rect)
                .onTapGesture {
                    index += 1
                    zIndex = index
                    withAnimation(.snappy) {
                        showOptions.toggle()
                    }
                }
                .zIndex(10)
                
                if showOptions && anchor == .bottom{
                    OptionsView()
                }
            }
            .clipped()
            .contentShape(.rect)
            .background((scheme == .dark ? Color.black : Color.white)
                .shadow(.drop(color: selection != nil ? .accent.opacity(0.6) : .text.opacity(0.3), radius: 4)), in: .rect(cornerRadius: cornerRadius))
            .frame(height: size.height, alignment: anchor == .top ? .bottom : .top)
            .overlay(alignment: .topLeading){
                if selection != nil{
                    Text(hint)
                        .foregroundStyle(.text.opacity(0.4))
                        .font(.caption)
                        .lineLimit(1)
                        .padding(.horizontal, 5)
                        .background(.themeBG)
                        .cornerRadius(5)
                        .offset(x: 8, y: -6)
                }
            }
        }
        .frame(height: height)
        .frame(maxWidth: .infinity, alignment: .leading)
        .zIndex(zIndex)
    }
    
    /// Options View
    @ViewBuilder
    func OptionsView() -> some View {
        VStack(spacing: 10) {
            ForEach(options, id: \.self) { option in
                HStack(spacing: 0) {
                    Text(option)
                        .lineLimit(1)
                    
                    Spacer(minLength: 0)
                    
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .opacity(selection == option ? 1 : 0)
                }
                .foregroundStyle(selection == option ? Color.primary : Color.gray)
                .animation(.none, value: selection)
                .frame(height: 40)
                .contentShape(.rect)
                .onTapGesture {
                    withAnimation(.snappy) {
                        selection = option
                        /// Closing Drop Down View
                        showOptions = false
                    }
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 5)
        .transition(.move(edge: anchor == .top ? .bottom : .top))
    }
    
    /// Drop Down Direction
    enum Anchor {
        case top
        case bottom
    }
}
