//
//  CoinViewModel.swift
//  IOS17-Swift
//
//  Created by xqsadness on 13/12/2023.
//

import Foundation
import Combine

class CoinViewModel: ObservableObject{
    @Published var data: CoinDIModel?
    
    var cancellables: AnyCancellable?
    var service: NetworkingManagerProtocol
    
    init(service: NetworkingManagerProtocol){
        self.service = service
        
        getData()
    }
    
    func getData(){
        guard let url = URL(string: "https://ipinfo.io/161.185.160.93/geo") else { return }
        
        cancellables = service.download(url: url)
            .decode(type: CoinDIModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: service.handleCompeltion) { data in
                self.data = data
            }
        //            .store(in: &cancellables)
    }
}
