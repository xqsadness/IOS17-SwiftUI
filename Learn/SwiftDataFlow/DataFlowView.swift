//
//  DataFlowView.swift
//  IOS17-Swift
//
//  Created by darktech4 on 08/12/2023.
//

import SwiftUI
import SwiftData

@Observable
class ViewModel{
    init(){
       //init
    }
    
    var name = "iamblue "
    var count = 99942
}

struct DataFlowView: View {
  @Bindable var vm = ViewModel()
    
    var body: some View {
        VStack(alignment: .center){
            Text("\(vm.count)")
                        
            TextField("Name", text: $vm.name)
                .textFieldStyle(.roundedBorder)
            
            Button{
                vm.count += 1
                vm.name = "change name \(String(Int.random(in: 1...19)))"
            }label: {
                Text("Add")
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    DataFlowView()
}
