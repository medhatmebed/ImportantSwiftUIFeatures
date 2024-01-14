//
//  MockDataServiceExample.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/14/24.
//

import SwiftUI

struct DataModel {
    let title: String
}

protocol DataServiceProtocol {
    func fetchData(completion: @escaping (Result<[DataModel], Error>) -> Void)
}


class MockDataService: DataServiceProtocol {
    func fetchData(completion: @escaping (Result<[DataModel], Error>) -> Void) {
        let mockData = [
            DataModel(title: "M"),
            DataModel(title: "F")
            // ... your mock data here
        ]
        completion(.success(mockData))
    }
}

class ViewModel: ObservableObject {
    @Published var data: [DataModel] = []

    private let service: DataServiceProtocol

    init(service: DataServiceProtocol) { // Inject real service in production
        self.service = service
    }

    func fetchData() {
        service.fetchData { result in
            switch result {
            case .success(let data):
                self.data = data
            case .failure(let error): break
                // Handle error
            }
        }
    }
}

func testViewModelFetchesData() {
    let mockService = MockDataService()
    let viewModel = ViewModel(service: mockService)

    // Verify that the view model fetches data and updates its state
    // ...
}

struct MockDataServiceExample: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    MockDataServiceExample()
}
