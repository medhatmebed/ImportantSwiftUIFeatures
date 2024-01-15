//
//  MVVMExample.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/15/24.
//

import SwiftUI

final class MyManagerClass {
    func getData() async throws -> String {
        "some data"
    }
}
actor MyManagerActor {
    func getData() async throws -> String {
        "some data"
    }
}
@MainActor
final class MVVMExampleViewModel: ObservableObject {
    let managerClass = MyManagerClass()
    let managerActor = MyManagerActor()
    
    @Published private(set) var myData = "Starting text"
    private var tasks = [Task<Void, Never>]()
    
    func cancelTasks() {
        tasks.forEach({ $0.cancel() })
        tasks = []
    }
    
    func onCallToActionButtonPressed() {
        let task = Task {
            do {
                myData = try await managerClass.getData()

            } catch {
                
            }
        }
        tasks.append(task)
    }
}


struct MVVMExample: View {
    
    @StateObject private var viewModel = MVVMExampleViewModel()
    
    
    var body: some View {
        VStack {
            Button(viewModel.myData) {
                viewModel.onCallToActionButtonPressed()
            }
        }
    }
}

#Preview {
    MVVMExample()
}
