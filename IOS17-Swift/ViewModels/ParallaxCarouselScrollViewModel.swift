//
//  ParallaxCarouselScrollViewModel.swift
//  IOS17-Swift
//
//  Created by xqsadness on 01/12/2023.
//

import Foundation
import Combine

class ParallaxCarouselScrollViewModel: ObservableObject{
    
    @Published var imageData: [ImageUnsplash] = []
    @Published var isLoading: Bool = true
    
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        getImage()
    }
    
    private func getImage(){
        
        let urlUnsplash = "https://api.unsplash.com/photos/?client_id=XWZWXva1XGdYNuIjZ8xJf6CmdzeZZm09PhOpUuUKAuA"
        
        guard let url = URL(string: urlUnsplash) else {return}
        
        NetworkingManager.download(url: url)
            .decode(type: [ImageUnsplash].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompeltion) { [weak self] returnedImage in
                self?.imageData = returnedImage
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}

struct ImageUnsplash: Codable{
    var id: String
    var user: User
    var urls: Urls
}

struct User: Codable{
    var name: String
    var username: String
}

struct Urls: Codable{
    var raw: String
    var full: String
    var regular: String
    var small: String
    var thumb: String
}
