//
//  TabFloating.swift
//  IOS17-Swift
//
//  Created by xqsadness on 29/8/24.
//

import SwiftUI

enum TabFloating: String, CaseIterable{
    case home = "house"
    case search = "magnifyingglass"
    case notifications = "bell"
    case settings = "gearshape"
    
    var title: String{
        switch self{
        case .home: "Home"
        case .search: "Search"
        case .notifications: "Notifications"
        case .settings: "Settings"
        }
    }
}
