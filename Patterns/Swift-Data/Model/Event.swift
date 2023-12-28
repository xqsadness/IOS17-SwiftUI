//
//  Event.swift
//  IOS17-Swift
//
//  Created by xqsadness on 28/12/2023.
//

import Foundation
import SwiftData

@Model
class Event{
    var name: String
    var location: String
    var people = [Person]()
//  or @Relationship(deleteRule: .cascade, inverse: \Person.metAt) var people: [Person]
    
    init(name: String, location: String) {
        self.name = name
        self.location = location
    }
}
