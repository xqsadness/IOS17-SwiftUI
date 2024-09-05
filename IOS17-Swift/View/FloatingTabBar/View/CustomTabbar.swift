//
//  CustomTabbar.swift
//  IOS17-Swift
//
//  Created by xqsadness on 29/8/24.
//

import SwiftUI
import CoreFoundation

//MARK: Available in xcode 16

//struct CustomTabbar: View {
//    var activeForeground:Color = .white
//    var activeBackground:Color = .blue
//    @Binding var activeTab: TabFloating
//    //For matched geometry effect
//    @Namespace private var animation
//    //view props
//    @State private var tabLocation: CGRect = .zero
//    var body: some View {
//        let status = activeTab == .home || activeTab == .search
//        
//        HStack(spacing: !status ? 0 : 12){
//            HStack(spacing: 0) {
//                ForEach(TabFloating.allCases, id: \.rawValue) { tab in
//                    Button {
//                        activeTab = tab
//                    } label: {
//                        HStack(spacing: 5) {
//                            Image(systemName: "\(tab.rawValue)")
//                                .font(.title3)
//                                .frame(width: 30, height: 30)
//                            
//                            if activeTab == tab {
//                                Text("\(tab.title)")
//                                    .font(.caption)
//                                    .fontWeight(.semibold)
//                                    .lineLimit(1)
//                            }
//                        }
//                        .foregroundStyle(activeTab == tab ? activeForeground : .gray)
//                        .padding(.vertical,2)
//                        .padding(.leading,10)
//                        .padding(.trailing,15)
//                        .contentShape(.rect)
//                        .background{
//                            if activeTab == tab{
//                                Capsule()
//                                    .fill(activeBackground.gradient)
//                                    //onGeometryChange available in xcode 16
//                                    .onGeometryChange(for: CGRect.self, of: { $0.frame(in: .named("TABBARVIEW"))
//                                    }, action: { newValue in
//                                        tabLocation = newValue
//                                    })
//                                    .matchedGeometryEffect(id: "ACTIVETABFLOAT", in: animation)
//                            }
//                        }
//                    }
//                    .buttonStyle(.plain)
//                }
//            }
//            .background(alignment: .leading){
//                Capsule()
//                    .fill(activeBackground.gradient)
//                    .frame(width: tabLocation.width, height: tabLocation.height)
//                    .offset(x: tabLocation.minX)
//            }
//            .coordinateSpace(.named("TABBARVIEW"))
//            .padding(.horizontal, 5)
//            .frame(height: 45)
//            .background(
//                .background
//                    .shadow(.drop(color: .black.opacity(0.08), radius: 5, x: 5, y: 5))
//                    .shadow(.drop(color: .black.opacity(0.06), radius: 5, x: -5, y: -5)), in: .capsule
//            )
//            .zIndex(10)
//            
//            Button{
//                
//            }label: {
//                Image(systemName: activeTab == .home ? "person.fill" : "slider.vertical.3")
//                    .font(.title3)
//                    .frame(width: 42, height: 42)
//                    .foregroundStyle(activeForeground)
//                    .background(activeBackground.gradient)
//                    .clipShape(.circle)
//            }
//            .allowsHitTesting(status)
//            .offset(x: status ? 0 : -20)
//            .padding(.leading, status ? 0 : -42)
//        }
//        .padding(.bottom, 5)
//        .animation(.smooth(duration: 0.3), value: activeTab)
//    }
//}
//
////#Preview {
////    FloatingTabBarView()
////}
//
//private struct GroundReflectionViewModifier: ViewModifier {
//    let offsetY: CGFloat
//    func body(content: Content) -> some View {
//        content
//            .background(
//                content
//                    .mask(
//                        LinearGradient(
//                            gradient: Gradient(stops: [.init(color: .white, location: 0.0), .init(color: .clear, location: 0.7)]),
//                            startPoint: .bottom,
//                            endPoint: .top)
//                    )
//                    .scaleEffect(x: 1.0, y: -1.0, anchor: .bottom)
//                    .opacity(0.3)
//                    .offset(y: offsetY)
//            )
//    }
//}
//
//extension View {
//    func reflection(offsetY: CGFloat = 1) -> some View {
//        modifier(GroundReflectionViewModifier(offsetY: offsetY))
//    }
//}
//
//struct GroundReflectionViewModifier_Previews: PreviewProvider {
//    static var previews: some View {
//        HStack {
//            Text("abcbcbcbc")
//                .bold()
//                .font(.title)
//                .reflection()
//        }
//    }
//}
