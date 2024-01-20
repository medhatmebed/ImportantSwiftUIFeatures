//
//  DependencyInjectionSwiftUI.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/20/24.
//

import SwiftUI

import SwiftUI
import Combine

// PROPLEMS OF SINGLETON : -
// 1. SINGLETONS ARE GLOBALS
// 2. CAN'T CUSTOMIZE THE INIT!
// 3. CAN'T SWAP OUT DEPENDENCIES

struct PostModel: Identifiable, Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

protocol DataServiceProtocolDI {
    func getData() -> AnyPublisher<[PostModel], Error>
}

class ProductionDataService: DataServiceProtocolDI {
    
    //static let instance = ProductDataService() // Singleton
    
    
   // let url: URL = URL(string: "https://jsonplaceholder.typicode.com/posts")!
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func getData() -> AnyPublisher<[PostModel], Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map({ $0.data })
            .decode(type: [PostModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
}

class MockDataServiceDI: DataServiceProtocolDI {
    
    let testData: [PostModel]
    
    init(data: [PostModel]?) {
        self.testData = data ?? [
            PostModel(userId: 1, id: 1, title: "One", body: "One"),
            PostModel(userId: 2, id: 2, title: "Two", body: "Two")
        ]
    }
    
    func getData() -> AnyPublisher<[PostModel], Error> {
        Just(testData)
            .tryMap({ $0 })
            .eraseToAnyPublisher()
    }
    
    
}



class DependencyInjectionViewModel: ObservableObject {
    
    @Published var dataArray = [PostModel]()
    var cancellabels = Set<AnyCancellable>()
    let dataService: DataServiceProtocolDI
    
    init(dataService: DataServiceProtocolDI) {
        self.dataService = dataService
        loadPosts()
    }
    
    private func loadPosts() {
        dataService.getData()
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("error downloading data \(error)")
                case .finished:
                    print("it supposed to be downloaded")
                }
            } receiveValue: { [weak self] returnedPosts in
                self?.dataArray = returnedPosts
            }
            .store(in: &cancellabels)

    }
    
    
}


struct DependencyInjectionBootcamp: View {
    
    @StateObject var vm: DependencyInjectionViewModel
    
    init(dataService: DataServiceProtocolDI) {
        _vm = StateObject(wrappedValue: DependencyInjectionViewModel(dataService: dataService))
    }
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(vm.dataArray) { post in
                    Text(post.title)
                }
            }
        }
    }
}

#Preview {
    let dataService = ProductionDataService(url: URL(string: "https://jsonplaceholder.typicode.com/posts")!)
   // let dataService = MockDataService(data: nil)
    return DependencyInjectionBootcamp(dataService: dataService)
}
