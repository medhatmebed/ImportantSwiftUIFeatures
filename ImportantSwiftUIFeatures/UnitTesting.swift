//
//  UnitTesting.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/17/24.
//

import Foundation

// Protocol for data service
protocol DataServiceUnitTesting {
    func fetchData(completion: (Result<Data, Error>) -> Void)
}

// Real data service implementation
class RealDataService: DataServiceUnitTesting {
    func fetchData(completion: (Result<Data, Error>) -> Void) {
        
    }
    
    // ... actual network calls
}

// Mock data service implementation
class MockDataServiceUnitTesing: DataServiceUnitTesting {
    var dataToReturn: Data?
    var errorToReturn: Error?

    func fetchData(completion: (Result<Data, Error>) -> Void) {
        if let error = errorToReturn {
            completion(.failure(error))
        } else {
            completion(.success(dataToReturn ?? Data()))
        }
    }
}

// Class using the data service
class MyClass {
    var dataService: DataServiceUnitTesting

    init(dataService: DataServiceUnitTesting) {
        self.dataService = dataService
    }

    func doSomething() {
        dataService.fetchData { result in
            // Handle data or error
        }
    }
}

//// Unit test
//class MyClassTests: XCTestCase {
//    func testDoSomethingSuccess() {
//        let mockDataService = MockDataServiceUnitTesing()
//        mockDataService.dataToReturn = // ... some test data
//
//        let myClass = MyClass(dataService: mockDataService)
//        myClass.doSomething()
//
//        // Assert expected behavior
//    }
//}
