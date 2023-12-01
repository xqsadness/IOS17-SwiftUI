//
//  TripCard.swift
//  IOS17-Swift
//
//  Created by darktech4 on 01/12/2023.
//

import SwiftUI

struct TripCard: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var subTitle: String
    var image: String
}

var tripCards: [TripCard] = [
    .init(title: "London", subTitle: "England", image: "Pic 1"),
    .init(title: "New York", subTitle: "USA", image: "Pic 2"),
    .init(title: "France", subTitle: "Moutain", image: "Pic 3")
]
