//
//  Person.swift
//  IOS17-Swift
//
//  Created by xqsadness on 28/12/2023.
//

import Foundation
import SwiftData

@Model
class Person{
    @Attribute(originalName: "name") var fullName: String
    var emailAddress: String
    var details: String
    
    var metAt: Event?
    @Attribute(.externalStorage) var photo: Data?
    
    @Relationship(inverse: \Job.people) var jobs: [Job]
    
    init(name: String, emailAddress: String, details: String, metAt: Event? = nil, photo: Data? = nil, jobs: [Job]) {
        self.fullName = name
        self.emailAddress = emailAddress
        self.details = details
        self.metAt = metAt
        self.photo = photo
        self.jobs = jobs
    }
}

@Model
class Job{
    var name: String
    var jobDescription: String
    var salary: String
    
    var people: [Person]
  
    init(name: String, jobDescription: String, salary: String, people: [Person]) {
        self.name = name
        self.jobDescription = jobDescription
        self.salary = salary
        self.people = people
    }
}
