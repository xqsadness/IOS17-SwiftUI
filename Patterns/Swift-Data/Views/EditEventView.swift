//
//  EditEventView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 28/12/2023.
//

import SwiftUI

struct EditEventView: View {
    @Bindable var event: Event
    
    var body: some View {
        Form{
            TextField("Name of event", text: $event.name)
            TextField("Location", text: $event.location)
        }
        .navigationTitle("Edit event")
        .navigationBarTitleDisplayMode(.inline)
    }
}
