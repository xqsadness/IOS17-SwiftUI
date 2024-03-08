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
