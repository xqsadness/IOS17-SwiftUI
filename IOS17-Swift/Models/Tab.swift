//
//  Tab.swift
//  IOS17-Swift
//
//  Created by xqsadness on 24/02/2024.
//

import SwiftUI

//Tab's for YouTube Mini Player Animation
enum Tab: String, CaseIterable{
    case home = "Home"
    case shorts = "Shorts"
    case subscriptions = "subscriptions"
    case you = "You"
    
    var symbol: String{
        switch self{
        case .home:
            "house.fill"
        case .shorts:
            "video.badge.waveform.fill"
        case .subscriptions:
            "play.square.stack.fill"
        case .you:
            "person.circle.fill"
        }
    }
}
struct CubeOffset: View {
    @State private var yellowSquareAnimationX = CGFloat(-25)
    @State private var yellowSquareAnimationY = CGFloat(25)
    
    @State private var purpleSquareAnimationX = CGFloat(25)
    @State private var purpleSquareAnimationY = CGFloat(-25)
    
    @State private var greenSquareAnimationX = CGFloat(25)
    @State private var greenSquareAnimationY = CGFloat(25)
    
    @State private var orangeSquareAnimationX = CGFloat(-25)
    @State private var orangeSquareAnimationY = CGFloat(-25)
    var four_colors: [Color]
    
    var body: some View {
        ZStack{
            four_colors[0]
                .frame(width: 40, height: 40, alignment: .center)
                .offset(x: yellowSquareAnimationX, y: yellowSquareAnimationY)
                .animation(.timingCurve(0.33, 1, 0.68, 1, duration: 0.5))
            
            four_colors[1]
                .frame(width: 40, height: 40, alignment: .center)
                .offset(x: purpleSquareAnimationX, y: purpleSquareAnimationY)
                .animation(.timingCurve(0.33, 1, 0.68, 1, duration: 0.5))
            
            four_colors[2]
                .frame(width: 40, height: 40, alignment: .center)
                .offset(x: greenSquareAnimationX, y: greenSquareAnimationY)
                .animation(.timingCurve(0.33, 1, 0.68, 1, duration: 0.5))
            
            four_colors[3]
                .frame(width: 40, height: 40, alignment: .center)
                .offset(x: orangeSquareAnimationX, y: orangeSquareAnimationY)
                .animation(.timingCurve(0.33, 1, 0.68, 1, duration: 0.5))
            
        }//End of ZStack
        .onAppear(){
            yellowSquareAnimationX = -20
            yellowSquareAnimationY = 20
            purpleSquareAnimationX = 20
            purpleSquareAnimationY = -20
            greenSquareAnimationX = 20
            greenSquareAnimationY = 20
            orangeSquareAnimationX = -20
            orangeSquareAnimationY = -20
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                orangeSquareAnimationY = 20
                greenSquareAnimationY = -20
                yellowSquareAnimationX = 20
                purpleSquareAnimationX = -20
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                orangeSquareAnimationX = 20
                greenSquareAnimationX = -20
                yellowSquareAnimationY = -20
                purpleSquareAnimationY = 20
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                orangeSquareAnimationY = -20
                greenSquareAnimationY = 20
                yellowSquareAnimationX = -20
                purpleSquareAnimationX = 20
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                orangeSquareAnimationX = -20
                greenSquareAnimationX = 20
                yellowSquareAnimationY = 20
                purpleSquareAnimationY = -20
            }
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
                yellowSquareAnimationX = -20
                yellowSquareAnimationY = 20
                purpleSquareAnimationX = 20
                purpleSquareAnimationY = -20
                greenSquareAnimationX = 20
                greenSquareAnimationY = 20
                orangeSquareAnimationX = -20
                orangeSquareAnimationY = -20
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    orangeSquareAnimationY = 20
                    greenSquareAnimationY = -20
                    yellowSquareAnimationX = 20
                    purpleSquareAnimationX = -20
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    orangeSquareAnimationX = 20
                    greenSquareAnimationX = -20
                    yellowSquareAnimationY = -20
                    purpleSquareAnimationY = 20
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    orangeSquareAnimationY = -20
                    greenSquareAnimationY = 20
                    yellowSquareAnimationX = -20
                    purpleSquareAnimationX = 20
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    orangeSquareAnimationX = -20
                    greenSquareAnimationX = 20
                    yellowSquareAnimationY = 20
                    purpleSquareAnimationY = -20
                }
            }
            //MARK: - To fire Timer immediately
            // .fire()
        }
    }
}
