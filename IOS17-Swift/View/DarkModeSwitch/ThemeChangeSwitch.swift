//
//  ThemeChangeSwitch.swift
//  IOS17-Swift
//
//  Created by xqsadness on 25/12/2023.
//

import SwiftUI

struct ThemeChangeSwitch: View {
    var scheme: ColorScheme
    @AppStorage("userTheme") private var userTheme: Theme = .systemDedault
    //For sliding effect
    @Namespace private var animation
    //View props
    @State private var circleOffset: CGSize
    
    init(scheme: ColorScheme){
        self.scheme = scheme
        let isDark = scheme == .dark
        self._circleOffset = .init(initialValue: CGSize(width: isDark ? 30 : 150, height: isDark ? -25 : -150))
    }
    
    var body: some View {
        VStack(spacing: 5){
            Circle()
                .fill(userTheme.color(scheme).gradient)
                .frame(width: 150, height: 150)
                .mask {
                    //Inverted mask
                    Rectangle()
                        .overlay {
                            Circle()
                                .offset(circleOffset)
                                .blendMode(.destinationOut)
                        }
                }
            
            Text("Choose a style")
                .font(.title).bold()
                .padding(.top, 25)
            
            Text("Pop or subtle, Day or night.\nCustomize your interface.")
                .multilineTextAlignment(.center)
            
            //Custom Segmented Picker
            HStack(spacing: 0){
                ForEach(Theme.allCases, id: \.rawValue){theme in
                    Text(theme.rawValue)
                        .padding(.vertical, 10)
                        .frame(width: 100)
                        .background{
                            ZStack{
                                if userTheme == theme{
                                    Capsule()
                                        .fill(.themeBG)
                                        .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                                }
                            }
                            .animation(.snappy, value: userTheme)
                        }
                        .contentShape(.rect)
                        .onTapGesture {
                            userTheme = theme
                        }
                }
            }
            .padding(3)
            .background(.primary.opacity(0.06), in: .capsule)
            .padding(.top, 20)
        }
        //Max height = 410
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .frame(height: 410)
        .background(.themeBG)
        .clipShape(.rect(cornerRadius: 30))
        .padding(.horizontal, 15)
        .environment(\.colorScheme, scheme)
        .onChange(of: scheme, initial: false) { _, newValue in
            let isDark = newValue == .dark
            withAnimation(.bouncy) {
                circleOffset = CGSize(width: isDark ? 30 : 150, height: isDark ? -25 : -150)
            }
        }
    }
}

#Preview {
    ThemeChangeSwitch(scheme: .light)
}

//Theme
enum Theme: String, CaseIterable{
    case systemDedault = "Default"
    case light = "Light"
    case dark = "Dark"
    
    func color(_ scheme: ColorScheme) -> Color{
        switch self{
        case .systemDedault:
            return scheme == .dark ? .moon : .sun
        case .light:
            return .sun
        case .dark:
            return .moon
        }
    }
    
    var colorScheme: ColorScheme?{
        switch self{
        case .systemDedault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}
