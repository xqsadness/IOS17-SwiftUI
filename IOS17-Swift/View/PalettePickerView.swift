//
//  PalettePickerView.swift
//  IOS17-Swift
//
//  Created by darktech4 on 08/12/2023.
//

import SwiftUI

struct PalettePickerView: View {
    @State private var selectedColor = MyColors.red
    @State private var contrast: Double = 1
    @State private var clear = false
    
    var body: some View {
        VStack{
            Image("test-img")
                .resizable()
                .scaledToFit()
                .modifier(WithModifiers(selectedColor: selectedColor, contrast: contrast,clear: clear))
                .padding(.horizontal)
                .contextMenu{
                    clearApply
                    slider
                    pickerPalette
                }
        }
    }
}

#Preview {
    PalettePickerView()
}

enum MyColors: String, CaseIterable, Identifiable {
    case red, orange, yellow, green, blue, indigo, black
    var id: Self {self }
    var color: Color {
        switch self {
        case .red: .red
        case .orange: .orange
        case .yellow: .yellow
        case .green: .green
        case .blue: .blue
        case .indigo: .indigo
        case .black: .black
        }
    }
}

extension PalettePickerView{
    
    private var pickerPalette: some View{
//        Menu(selectedColor.rawValue) {
            Picker("My Color", selection: $selectedColor) {
                ForEach (MyColors.allCases) { myColor in
                    Label(myColor.rawValue, systemImage: "square")
                        .tint(myColor.color)
                }
            }
            .paletteSelectionEffect(.symbolVariant(.fill))
            .pickerStyle(.palette)
//        }
//        .buttonStyle(.borderedProminent)
//        .tint (selectedColor.color.gradient)
    }
    
    private var slider: some View{
        Slider(value: $contrast, in: 0.5...3.0){
            Text("Contrast: \(contrast, format: .number)")
        }
    }
    
    private var clearApply: some View{
        ControlGroup{
            Button{
                withAnimation {
                    clear = true
                }
            }label: {
                Label("Clear", systemImage: "x.circle")
            }
            
            Button{
                withAnimation {
                    clear = false
                }
            }label: {
                Label("Apply", systemImage: "checkmark")
            }
        }
    }
}

struct WithModifiers: ViewModifier{
    let selectedColor: MyColors
    let contrast: Double
    let clear: Bool
    
    func body(content: Content) -> some View {
        if clear{
            content
        }else{
            content
                .colorMultiply(selectedColor.color)
                .contrast(contrast)
        }
    }
}
