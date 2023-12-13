//
//  Combine.swift
//  IOS17-Swift
//
//  Created by xqsadness on 01/12/2023.
//

import Foundation
import Combine
import SwiftUI

struct CombineSearchView: View{
    @StateObject var vm: CombineVM
    
    //DI
    init(coinDataSevice: CoinDataService) {
        _vm = StateObject(wrappedValue: CombineVM(coinDataSevice: coinDataSevice))
    }
    
    var body: some View{
        VStack{
            ScrollView{
                if vm.isLoadData{
                    ProgressView()
                }else{
                    if vm.data.isEmpty{
                        Text("No data !")
                    }else{
                        ForEach(vm.data, id: \.id){ value in
                            Text(value.name)
                            Text("\(value.currentPrice)")
                        }
                    }
                }
            }
            
            TextField("textSearch", text: $vm.textSearch)
        }
        .padding()
    }
}

#Preview{
    CombineSearchView(coinDataSevice: CoinDataService())
}

class CombineVM: ObservableObject {
    @Published var textSearch: String = ""
    @Published var isLoadData: Bool = true
    @Published var data: [CoinModel] = []
    
    var cancellables: Set<AnyCancellable> = []
    var coinDataSevice: CoinDataService
    
    //DI
    init(coinDataSevice: CoinDataService) {
        self.coinDataSevice = coinDataSevice
        
        searchCoin()
    }
    
    func searchCoin(){
        $textSearch
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .combineLatest(self.coinDataSevice.$allCoins)
            .map { searchText, allCoins in
                guard !searchText.isEmpty else{
                    return allCoins
                }
                // filter with name and price
                return allCoins.filter( {$0.name.lowercased().contains(searchText.lowercased()) || String($0.currentPrice).contains(searchText.lowercased())} )
            }
            .sink { [weak self] filteredCoins in
                self?.isLoadData = false
                self?.data = filteredCoins
            }
            .store(in: &cancellables)
    }
}
  
