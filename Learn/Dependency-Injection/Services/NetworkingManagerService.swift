//
//  Network.swift
//  L-Swift
//
//  Created by xqsadness on 28/11/2023.
//

import SwiftUI
import Combine

// for DI
class NetworkingManagerService: ObservableObject, NetworkingManagerProtocol{
    
    enum NetworkingError: LocalizedError{
        case badURLResponse(url: URL)
        case unowned
        
        var errorDescription: String?{
            switch self{
            case .badURLResponse(url: let url): return "Bad response from url: \(url)"
            case .unowned: return "unowned error occured"
            }
        }
    }
    
     func download(url: URL) -> AnyPublisher<Data,Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try self.handleURLResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
     func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else{
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
     func handleCompeltion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
    
}
