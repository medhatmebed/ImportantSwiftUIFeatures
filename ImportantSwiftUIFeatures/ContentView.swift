//
//  ContentView.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/12/24.
//

import SwiftUI
import Combine

// Model
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

// Network Service
class DataService {
    func fetchPosts() -> AnyPublisher<[Post], Error> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Post].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

// ViewModel
class PostViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?

    private var cancellables: Set<AnyCancellable> = []
    private let dataService = DataService()

    func fetchPosts() {
        dataService.fetchPosts()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break // Do nothing for now
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }, receiveValue: { posts in
                self.posts = posts
            })
            .store(in: &cancellables)
    }
}

// SwiftUI View
struct ContentView: View {
    @ObservedObject var viewModel = PostViewModel()

    var body: some View {
        VStack {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(viewModel.posts, id: \.id) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchPosts()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
#Preview {
    ContentView()
}
