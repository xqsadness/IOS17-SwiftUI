//
//  FactoryView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 05/12/2023.
//

import SwiftUI

protocol Computer{
    func aboutDevice() -> String
}

struct OperatingSystem{
    enum SystemType: String{
        case iOS
        case iPadOS
        case macOS
    }
    
    var version: Int
    var type: SystemType
}

struct Mac: Computer{
    var system: OperatingSystem
    
    init(system: OperatingSystem) {
        self.system = system
    }
    
    func aboutDevice() -> String {
        return "Mac \(system.type) - \(system.version)"
    }
}

struct Ipad: Computer{
    var system: OperatingSystem
    
    init(system: OperatingSystem) {
        self.system = system
    }
    
    func aboutDevice() -> String {
        return "Ipad \(system.type) - \(system.version)"
    }
}

struct Iphone: Computer{
    var system: OperatingSystem
    
    init(system: OperatingSystem) {
        self.system = system
    }
    
    func aboutDevice() -> String {
        return "Iphone \(system.type) - \(system.version)"
    }
}

struct ComputerFactory{
    static func makeComputer(system: OperatingSystem) -> Computer{
        switch system.type{
        case .iOS:
            return Iphone(system: system)
        case .iPadOS:
            return Ipad(system: system)
        case .macOS:
            return Mac(system: system)
        }
    }
}

struct FactoryView: View {
   @State var systems: [OperatingSystem] = [
        OperatingSystem(version: 2, type: .iOS),
        OperatingSystem(version: 6, type: .macOS),
        OperatingSystem(version: 2, type: .iPadOS),
    ]
    
    var body: some View {
        VStack{
            ForEach(systems, id: \.type.hashValue){ system in
                let factory = ComputerFactory.makeComputer(system: system)
                Text(factory.aboutDevice())
            }
            
            Button{
                self.systems.append(OperatingSystem(version: Int.random(in: 1...100), type: .iOS))
            }label: {
                Text("Add system")
            }
            .padding()
        }
    }
}

#Preview {
    FactoryView()
}
