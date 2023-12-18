//
//  NumberGeneratorService.swift
//  IOS17-Swift
//
//  Created by xqsadness on 13/12/2023.
//

import Foundation

class NumberGeneratorService: ObservableObject, NumberGeneratorProtocol{
    func getRandomNumber() -> Int{
        return Int.random(in: 1...10000)
    }
}
