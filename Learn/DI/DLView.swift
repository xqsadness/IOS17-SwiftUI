
import SwiftUI
import Combine
import Foundation

// Service protocols
protocol NumberGeneratorProtocol {
    func getRandomNumber() -> Int
}

struct NumberGeneratorView: View {
    @StateObject private var vm: NumberGeneratorViewModel
    
    init( numberGenerator: NumberGeneratorProtocol ) {
        _vm = StateObject(wrappedValue: NumberGeneratorViewModel(numberGenerator: numberGenerator))
    }
    
    var body: some View {
        VStack{
            Text(vm.number.description)
            Button("Generate New Number") {
                vm.getRamDomNumber()
            }
        }
    }
}

class NumberGeneratorService: ObservableObject, NumberGeneratorProtocol{
    func getRandomNumber() -> Int{
        return Int.random(in: 1...10000)
    }
}

class NumberGeneratorViewModel: ObservableObject{
    private let numberGenerator: NumberGeneratorProtocol
    
    init(numberGenerator: NumberGeneratorProtocol) {
        print("___.___")
        self.numberGenerator = numberGenerator
    }
    
    @Published var number = 0
    
    func getRamDomNumber(){
        self.number = numberGenerator.getRandomNumber()
    }
}

//--------------------------------------------------------------//--------------------------------------------------------------

// Service protocols
protocol NetworkingManagerProtocol {
    func download(url: URL) -> AnyPublisher<Data, Error>
    
    func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data
    
    func handleCompeltion(completion: Subscribers.Completion<Error>)
}

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

class CoinViewModel: ObservableObject{
    @Published var data: Model?
    
    var cancellables: AnyCancellable?
    var service: NetworkingManagerProtocol
    
    init(service: NetworkingManagerProtocol){
        self.service = service
        
        getData()
    }
    
    func getData(){
        guard let url = URL(string: "https://ipinfo.io/161.185.160.93/geo") else { return }
        
        cancellables = service.download(url: url)
            .decode(type: Model.self, decoder: JSONDecoder())
            .sink(receiveCompletion: service.handleCompeltion) { data in
                self.data = data
            }
        //            .store(in: &cancellables)
    }
}

struct Model: Codable{
    var ip: String
    var city: String
    var country: String
    var region: String
}
