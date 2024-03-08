//
//  PlayerItem.swift
//  IOS17-Swift
//
//  Created by xqsadness on 24/02/2024.
//

import SwiftUI

// Player Item Model for YouTube Mini Player Animation

let dummyDescription: String = " Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book."

struct PlayerItem: Identifiable, Equatable {
    let id: UUID = .init()
    var title: String
    var author: String
    var image: String
    var description: String = dummyDescription
}

//Simple data
var items: [PlayerItem] = [
    .init(
        title: "Joji - Die For You",
        author: "Joji",
        image: "jj1"
    ),
    .init(
        title: "Joji - SLOW DANCING IN THE DARK",
        author: "88rising",
        image: "jj2"
    ),
    .init(
        title: "Joji - Gimme Love (Official Video)",
        author: "88rising",
        image: "jj3"
    ),
    .init(
        title: "Joji - Sanctuary (Official Video)",
        author: "88rising",
        image: "jj4"
    )
]

//PlayerConfig
struct PlayerConfig: Equatable {
    var position: CGFloat = .zero
    var lastPosition: CGFloat = .zero
    var progress: CGFloat = .zero
    var selectedPlayerItem: PlayerItem?
    var showMiniPlayer: Bool = false
    mutating func resetPosition(){
        position = .zero
        lastPosition = .zero
        progress = .zero
    }
}
