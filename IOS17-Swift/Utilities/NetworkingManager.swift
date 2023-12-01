//
//  NetworkingManager.swift
//  DefualtSource
//
//  Created by xqsadness on 14/11/2023.
//

import Foundation
import Combine

class NetworkingManager{
    
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
    
    static func download(url: URL) -> AnyPublisher<Data,Error>{
        return URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data{
        guard let response = output.response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else{
            throw NetworkingError.badURLResponse(url: url)
        }
        return output.data
    }
    
    static func handleCompeltion(completion: Subscribers.Completion<Error>){
        switch completion{
        case .finished:
            break
        case .failure(let err):
            print(err.localizedDescription)
        }
    }
}
