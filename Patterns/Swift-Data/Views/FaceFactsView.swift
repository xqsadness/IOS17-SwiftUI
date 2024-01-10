//
//  FaceFactsView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 28/12/2023.
//

import SwiftUI
import SwiftData

struct FaceFactsView: View {
    
    @Environment(\.modelContext) var modelContext
    @State private var path = NavigationPath()
    
    @State private var sortOrder = [SortDescriptor(\Person.fullName)]
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack(path: $path){
            PeopleView(searchString: searchText, sortOrder: sortOrder)
                .navigationTitle("Face facts")
                .navigationDestination(for: Person.self) { person in
                    EditPersonView(person: person, navigationPath: $path)
                }
                .toolbar{
                    Menu("Sort", systemImage: "arrow.up.arrow.down"){
                        Picker("Sort", selection: $sortOrder){
                            Text("Name (A-Z)")
                                .tag([SortDescriptor(\Person.fullName)])
                            
                            Text("Name (Z-A)")
                                .tag([SortDescriptor(\Person.fullName, order: .reverse)])
                        }
                    }
                    
                    Button("Add person", systemImage: "plus") {
                        addPerson()
                    }
                }
                .searchable(text: $searchText)
        }
    }
    
    func addPerson(){
        let person = Person(name: "", emailAddress: "", details: "", jobs: [])
        
        modelContext.insert(person)
        path.append(person)
    }    
}

#Preview {
    FaceFactsView()
}
