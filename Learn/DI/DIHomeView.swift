//
//  DIView.swift
//  IOS17-Swift
//
//  Created by darktech4 on 01/12/2023.
//

import SwiftUI
import Combine


// Dependency container
class DependencyContainer {
    static let shared = DependencyContainer()
    
    // Dependencies
    let numberGenerator: NumberGeneratorProtocol
    let networkingManager: NetworkingManagerProtocol
    
    private init() {
        self.numberGenerator = NumberGeneratorService()
        self.networkingManager = DLNetworkingManager()
    }
}

struct DIHomeView: View {
    let dependencyContainer = DependencyContainer.shared

    var body: some View {
        VStack{
            NumberGeneratorView(numberGenerator: dependencyContainer.numberGenerator)
            CoinView(service: dependencyContainer.networkingManager)
        }
    }
}

#Preview {
    DIHomeView()
}
