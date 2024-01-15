//
//  DownloadImageAsyncCombineEscaping.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/15/24.
//

import SwiftUI
import Combine

class DownloadImageAsyncImageLoader {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              200..<300 ~= response.statusCode else {
            return nil
        }
        return image
    }
    
    func downloadImageWithEscaping(completionHandler: @escaping (UIImage?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            let image = self?.handleResponse(data: data, response: response)
            completionHandler(image, nil)
        }
        .resume()
    }
    
    func downloadWithCombine() -> AnyPublisher<UIImage?, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(handleResponse)
            .mapError({ $0 })
            .eraseToAnyPublisher()
    }
    
    func downloadWithAsyncAwait() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
    
    
    
}

class DownloadImageAsyncCombineEscapingViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    var cancellables = Set<AnyCancellable>()
    
    func fetchImage() {
//        loader.downloadWithCombine()
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { _ in
//                
//            }, receiveValue: { [weak self] image in
//                self?.image = image
//            })
//                .store(in: &cancellables)
//        loader.downloadImageWithEscaping { [weak self] image, error in
//            self?.image = image
//        }
        
        Task {
            image = try await loader.downloadWithAsyncAwait()
        }
        
    }
    
}

struct DownloadImageAsyncCombineEscaping: View {
    
    @StateObject private var viewMode = DownloadImageAsyncCombineEscapingViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewMode.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear {
            viewMode.fetchImage()
        }
    }
}

#Preview {
    DownloadImageAsyncCombineEscaping()
}
