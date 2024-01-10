//
//  EditJobView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 04/01/2024.
//

import SwiftUI

struct EditJobView: View {
    @Bindable var job: Job
    
    var body: some View {
        Form{
            TextField("Name job", text: $job.name)
            TextField("JD", text: $job.jobDescription)
            TextField("Salary", text: $job.salary)

        }
        .navigationTitle("Edit Job")
        .navigationBarTitleDisplayMode(.inline)
    }
}
