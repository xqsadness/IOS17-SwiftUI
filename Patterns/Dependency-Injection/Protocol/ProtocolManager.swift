//
//  ProtocolManager.swift
//  IOS17-Swift
//
//  Created by xqsadness on 13/12/2023.
//

import Foundation
import Combine

protocol NumberGeneratorProtocol {
    func getRandomNumber() -> Int
}

protocol NetworkingManagerProtocol {
    func download(url: URL) -> AnyPublisher<Data, Error>
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data
    
    func handleCompeltion(completion: Subscribers.Completion<Error>)
}
