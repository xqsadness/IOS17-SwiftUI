//
//  DarkLightModeView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 04/12/2023.
//

import SwiftUI

struct DarkLightModeView: View {
    @AppStorage("colorScheme") var colorScheme = "dark"
    @AppStorage("currentMode") var currentMode = ""
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            VStack{
                Spacer()
                ZStack{
                    RoundedRectangle(cornerRadius: 30)
                        .frame(height: 270).foregroundStyle(.bg)
                    
                    VStack(spacing: 20){
                        HStack{
                            Text("Appearance") .bold().font(.title).foregroundStyle(.primary)
                            Spacer()
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .onTapGesture {
                                    withAnimation {
                                        show.toggle()
                                    }
                                }
                        }
                        .padding(.horizontal)
                        Divider().padding(.horizontal,30)
                        
                        HStack(spacing: 40){
                            Button{
                                colorScheme = "light"
                                currentMode = "light"
                            }label: {
                                ButtonView(mode: .light, currentMode: $currentMode, Rbg: .lb, Rbgi: .lbi, ibg: .white)
                            }
                            .tint(.primary)
                            
                            Button{
                                colorScheme = "dark"
                                currentMode = "dark"
                            }label: {
                                ButtonView(mode: .dark, currentMode: $currentMode, Rbg: Color(hex: "3B383B"), Rbgi: Color(hex: "565656"), ibg: .black)
                            }
                            .tint(.primary)
                            
                            Button{
                                colorScheme = "system"
                                currentMode = "system"
                            }label: {
                                ZStack{
                                    ButtonView(mode: .system, currentMode: $currentMode, Rbg: .lb, Rbgi: .lbi, ibg: .white)
                                    
                                    ButtonView(mode: .system, currentMode: $currentMode, Rbg: Color(hex: "3B383B"), Rbgi: Color(hex: "565656"), ibg: .black)
                                        .mask {
                                            RoundedRectangle(cornerRadius: 10)
                                                .frame(width: 50, height: 200)
                                                .offset(x: -24)
                                        }
                                }
                            }
                        }
                        
                    }
                }
                .padding(.horizontal)
            }
            .offset(y: show ? 300 : -30)
        }
    }
}

#Preview {
    DarkLightModeView( show: .constant(false))
}

enum AppearanceMode: String{
    case dark, light, system
}

struct ButtonView: View {
    var mode: AppearanceMode
    @Binding var currentMode: String
    
    var Rbg: Color
    var Rbgi: Color
    var ibg: Color
    
    var body: some View {
        VStack(spacing: 20){
            VStack{
                Circle().frame(width: 20, height: 20)
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 49, height: 6)
                
                VStack(spacing: 5){
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 38, height: 6)
                }
                .frame(width: 50, height: 50)
                .background(ibg, in: RoundedRectangle(cornerRadius: 5))
            }
            .foregroundStyle(Rbgi)
            .padding(8)
            .overlay(content: {
                if currentMode == mode.rawValue{
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 2)
                        .padding(-3)
                }
            })
            .background(Rbg,in: RoundedRectangle(cornerRadius: 7))
            
            Text(String(describing: mode).capitalized)
                .foregroundStyle(currentMode == mode.rawValue ? .text2 : .text)
                .font(.system(size: 15))
                .frame(width: 80, height: 25)
                .background(currentMode == mode.rawValue ? Color(hex: "000000") : Color(hex: "CDCFD6"), in: RoundedRectangle(cornerRadius: 10))
        }
        .scaleEffect(currentMode == mode.rawValue ? 1.1 : 0.9)
        .animation(.default, value: currentMode)
    }
}
