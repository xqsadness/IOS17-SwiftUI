//
//  CoinDataService.swift
//  IOS17-Swift
//
//  Created by xqsadness on 01/12/2023.
//

import SwiftUI
import Combine

class CoinDataService{
    @Published var allCoins: [CoinModel] = []
    
    var coinSubscription: AnyCancellable?
    
    init(){
        getCoins()
    }
    
    func getCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h&x_cg_demo_api_key=CG-6n4cetNqwzC1oJU7t3Xe4ebJ") else {
            return
        }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompeltion, receiveValue: { [weak self] coins  in
                self?.allCoins = coins
                self?.coinSubscription?.cancel()
            })
    }
}



