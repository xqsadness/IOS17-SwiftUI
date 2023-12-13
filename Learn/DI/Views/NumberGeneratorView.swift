//
//  NumberGeneratorView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 13/12/2023.
//

import SwiftUI

struct NumberGeneratorView: View {
    @StateObject private var vm: NumberGeneratorViewModel
    
    init( numberGenerator: NumberGeneratorProtocol ) {
        _vm = StateObject(wrappedValue: NumberGeneratorViewModel(numberGenerator: numberGenerator))
    }
    
    var body: some View {
        VStack{
            Text(vm.number.description)
            Button("Generate New Number") {
                vm.getRamDomNumber()
            }
        }
    }
}

#Preview {
    NumberGeneratorView(numberGenerator: NumberGeneratorService())
}
