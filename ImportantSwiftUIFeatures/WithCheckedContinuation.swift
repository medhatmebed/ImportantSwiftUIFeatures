//
//  WithCheckedContinuation.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/23/24.
//

import SwiftUI
/// continuation is essentially represents the paused state of your program's execution
/// Convert existing code to async/await: Continuations provide a way to rewrite code using completion handlers into the more modern async/await style.
class WithCheckedContinuationDataService {
    /// here we download the image using async await
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    /// here we convert regular call with completion handler into async await func
    func getData2(url: URL) async throws -> Data {
        /// continuation here represents the paused state of the concurrent task so we're waiting until the image returned
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    /// here we return the image
                    continuation.resume(returning: data)
                } else if let error = error {
                    /// here we throw the error
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
            }
            .resume()
        }
    }
    
}

class WithCheckedContinuationViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = WithCheckedContinuationDataService()
    func getData() async {
        guard let url = URL(string: "https://picsum.photos/300") else { return }
        
        do {
            /// we can see here we converted a regualar api call with completion handler into async await func
            let data = try await networkManager.getData2(url: url)
            
            if let image = UIImage(data: data) {
                /// we should receive the image on the main thread
                await MainActor.run {
                    self.image = image
                }
            }
            
        } catch {
            print(error)
        }
    }
    
}



struct WithCheckedContinuation: View {
    @StateObject private var viewModel = WithCheckedContinuationViewModel()
    
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.getData()
        }
    }
}

#Preview {
    WithCheckedContinuation()
}
