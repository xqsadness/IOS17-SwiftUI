//
//  Intro.swift
//  IOS17-Swift
//
//  Created by xqsadness on 04/07/2024.
//

import SwiftUI

struct Intro: Identifiable{
    var id = UUID().uuidString
    var title: String
    var subTitle: String
    var description: String
    var pic: String
    var color: LinearGradient
    var offset: CGSize = .zero
}
