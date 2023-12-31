//
//  EditPersonView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 28/12/2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditPersonView: View {
    
    @Environment(\.modelContext) var modelContext
    @Bindable var person: Person
    @Binding var navigationPath: NavigationPath
    
    @State private var selectedItem: PhotosPickerItem?
    
    @Query(sort: [
        SortDescriptor(\Event.name),
        SortDescriptor(\Event.location)
    ]) var events: [Event]
    
    var body: some View {
        Form{
            Section{
                if let imgData = person.photo,let uiImage = UIImage(data: imgData){
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                }
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Label("Select a photo", systemImage: "person")
                }
            }
            
            Section("Name and email"){
                TextField("Name", text: $person.fullName)
                    .textContentType(.name)
                    .foregroundStyle(.text)
                
                TextField("Email address", text: $person.emailAddress)
                    .textContentType(.emailAddress)
                    .textInputAutocapitalization(.never)
            }
            
            Section("Jobs"){
                if !person.jobs.isEmpty{
                    ForEach(person.jobs){ job in
                        Text(job.name)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                navigationPath.append(job)
                            }
                    }
                }
                
                Button("Add a new job") {
                    addJob()
                }
            }
            
            Section("Where did you meet them?"){
                Picker("Met at", selection: $person.metAt){
                    Text("Unk Event")
                        .tag(Optional<Event>.none)
                    
                    if !events.isEmpty{
                        Divider()
                        
                        ForEach(events){evt in
                            Text(evt.name)
                                .tag(Optional(evt))
                        }
                    }
                }
                
                Button("Add a new event") {
                    addEvent()
                }
            }
            
            Section("Notes"){
                TextField("Details about this person", text: $person.details, axis: .vertical)
            }
        }
        .navigationTitle("Edit person")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: Event.self) { evt in
            EditEventView(event: evt)
        }
        .navigationDestination(for: Job.self) { job in
            EditJobView(job: job)
        }
        .onChange(of: selectedItem, loadPhoto)
    }
    
    func addEvent(){
        let evt = Event(name: "", location: "")
        modelContext.insert(evt)
        navigationPath.append(evt)
    }
    
    func addJob(){
        let job = Job(name: "", jobDescription: "", salary: "", people: [])
        
        person.jobs.append(job)
        navigationPath.append(job)
    }
    
    func loadPhoto(){
        Task{ @MainActor in
            person.photo = try await selectedItem?.loadTransferable(type: Data.self)
        }
    }
}
