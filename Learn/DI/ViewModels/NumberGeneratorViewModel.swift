//
//  NumberGeneratorViewModel.swift
//  IOS17-Swift
//
//  Created by xqsadness on 13/12/2023.
//

import Foundation

class NumberGeneratorViewModel: ObservableObject{
    private let numberGenerator: NumberGeneratorProtocol
    
    init(numberGenerator: NumberGeneratorProtocol) {
        print("___.___")
        self.numberGenerator = numberGenerator
    }
    
    @Published var number = 0
    
    func getRamDomNumber(){
        self.number = numberGenerator.getRandomNumber()
    }
}
