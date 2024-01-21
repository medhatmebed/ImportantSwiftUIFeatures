//
//  AdvancedCombine.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/20/24.
//

import SwiftUI
import Combine

class AdvancedCombineDataService {
    
    @Published var basicPublisher = [String]()
    
    init() {
        publishFakeData()
    }
    
    private func publishFakeData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.basicPublisher = ["One", "Two", "Three"]
        }
    }
    
}

class AdvancedCombineViewModel: ObservableObject {
    
    @Published var data = [String]()
    let dataService = AdvancedCombineDataService()
    var cancellables = Set<AnyCancellable>()
    init() {
        addSubscribers()
    }
    
    private func addSubscribers() {
        dataService.$basicPublisher
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            } receiveValue: { [weak self] returnedData in
                self?.data = returnedData
            }
            .store(in: &cancellables)

    }
    
    
}

struct AdvancedCombine: View {
    
    @StateObject private var viewModel = AdvancedCombineViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.data, id: \.self) {
                    Text($0)
                        .font(.headline)
                }
            }
        }
        
    }
}

#Preview {
    AdvancedCombine()
}
