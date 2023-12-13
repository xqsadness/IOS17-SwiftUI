//
//  CoinView.swift
//  IOS17-Swift
//
//  Created by xqsadness on 13/12/2023.
//

import SwiftUI

struct CoinView: View{
    @StateObject var vm: CoinViewModel
    
    init(service: NetworkingManagerProtocol) {
        _vm = StateObject(wrappedValue: CoinViewModel(service: service))
    }
    
    var body: some View{
        VStack{
            if let data = vm.data{
                Text(data.country)
                Text(data.ip)
                Text(data.city)
                Text(data.region)
                    .foregroundColor(.black)
            }
        }
    }
}

#Preview {
    CoinView(service: NetworkingManagerService())
}
