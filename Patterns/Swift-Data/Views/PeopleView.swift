//
//  PeopleView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 28/12/2023.
//

import SwiftUI
import SwiftData

struct PeopleView: View {
    @Environment(\.modelContext) var modelContext
    @Query var people: [Person]
    
    init(searchString: String = "", sortOrder: [SortDescriptor<Person>] = []){
        _people = Query(filter: #Predicate{ person in
            if searchString.isEmpty{
                true
            }else{
                person.fullName.localizedStandardContains(searchString)
                ||  person.emailAddress.localizedStandardContains(searchString)
                || person.details.localizedStandardContains(searchString)
            }
        }, sort: sortOrder)
    }
    
    var body: some View {
        List{
            ForEach(people){ person in
                NavigationLink(value: person){
                    Text(person.fullName)
                }
            }
            .onDelete(perform: deletePeople)
        }
    }
    
    func deletePeople(at offsets: IndexSet){
        for offset in offsets{
            let person = people[offset]
            modelContext.delete(person)
        }
    }
}

#Preview {
    PeopleView()
}
