//
//  IOS17_SwiftApp.swift
//  IOS17-Swift
//
//  Created by xqsadness on 30/11/2023.
//

import SwiftUI
import SwiftData

@main
struct IOS17_SwiftApp: App {
    var body: some Scene {
        WindowGroup {
            RootView{
                ContentView()
            }
        }
        .modelContainer(for: Person.self)
    }
}
