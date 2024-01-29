//
//  EnvironmentObject.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/29/24.
//

import SwiftUI


class DataManager: ObservableObject {
    @Published var someData: String = "Initial value"
}

struct SomeView: View {
    @EnvironmentObject var dataManager: DataManager

    var body: some View {
        Text(dataManager.someData)
    }
}


struct EnvironmentObjectExample: View {
    @StateObject var dataManager = DataManager()

     var body: some View {
         SomeView()
             .environmentObject(dataManager)
     }
}

#Preview {
    EnvironmentObjectExample()
}
