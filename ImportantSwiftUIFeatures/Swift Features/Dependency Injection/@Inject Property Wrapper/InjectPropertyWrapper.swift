//
//  InjectPropertyWrapper.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/19/24.
//

import SwiftUI


protocol DependencyContainer {
    func resolve<T>() -> T
}

class AppContainer: DependencyContainer {
    private var dependencies: [AnyHashable: Any] = [:]

    func register<T>(_ dependency: T) {
        dependencies[ObjectIdentifier(T.self)] = dependency
    }

    func resolve<T>() -> T {
        guard let dependency = dependencies[ObjectIdentifier(T.self)] as? T else {
            fatalError("Dependency \(T.self) not registered")
        }
        return dependency
    }
}


@propertyWrapper
struct Inject<T> {
    private var container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }

    var wrappedValue: T {
        container.resolve()
    }
}

/*
 struct MyApp: App {
     let container = AppContainer()

     init() {
         container.register(MyNetworkManager())
         // ... register other dependencies
     }

     var body: some Scene {
         WindowGroup {
             ContentView()
                 .environmentObject(container) // Inject container into environment
         }
     }
 }
 */





protocol MyNetWorkManagerProtocol {
    func fetchData()
}
class MyNetWorkManagerClass: MyNetWorkManagerProtocol {
    func fetchData() {
        
    }
}





struct InjectPropertyWrapper: View {
    
 //  @Inject var networkManager: MyNetWorkManagerProtocol
    
    var body: some View {
        // ... use networkManager
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
   InjectPropertyWrapper()
}
