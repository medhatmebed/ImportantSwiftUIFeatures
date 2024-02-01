//
//  UsingTask.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/19/24.
//

import SwiftUI


class UsingTaskViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/1000") else { return }
            let (data, _) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
       // Task {
            do {
                guard let url = URL(string: "https://picsum.photos/1000") else { return }
                let (data, _) = try await URLSession.shared.data(from: url)
                DispatchQueue.main.async {
                    self.image2 = UIImage(data: data)
                }
            } catch {
                print(error.localizedDescription)
            }
     //   }
    }
    
}

struct UsingTaskHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("Click Me! ") {
                    UsingTask()
                }
            }
        }
    }
}

struct UsingTask: View {
    
    @StateObject private var viewModel = UsingTaskViewModel()
    @State private var task: Task<(), Never>? = nil
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        /// using Task is to execute asynchronous code.. you can you .task or Task
        /// if you use Task then you have to handle the cancelation of the task but if you use .task then it's automatically cancel the task after the view disappear
        .task {
            await viewModel.fetchImage()
        }
        .onDisappear {
            task?.cancel()
        }
        .onAppear {
            task = Task {
            //    await viewModel.fetchImage()
                await viewModel.fetchImage2()
            }
//            Task(priority: .high) {
//                await viewModel.fetchImage2()
//            }
        }
    }
}

#Preview {
    UsingTask()
}
