//
//  PreferenceKeyExample.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/22/24.
//

import SwiftUI

/// we use preferenceKeys to pass data from child view to parent views
///
struct PreferenceKeyExample: View {
    
    @State private var text = "Hello World!"
    
    var body: some View {
        NavigationStack {
            VStack {
                SecondaryScreen(text: text)
                    .navigationTitle("Navigation Title")
                /// in this example we use .customTitle as view modifier
                  //  .customTitle("Hello preference keys")
            }
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self, perform: { value in
            text = value
        })
    }
}
/// we add the custom preference key to the view extension to used as view modifiers
extension View {
    
    func customTitle(_ text: String) -> some View {
        preference(key: CustomTitlePreferenceKey.self, value: text)
    }
}

struct SecondaryScreen: View {
    
    let text: String
    @State private var newValue = ""
    
    var body: some View {
        Text(text)
            .onAppear {
                getDataFromDatabase()
            }
        /// notice here we can pass data from child view to the parent view 
            .customTitle("Hello preference keys from child view")
        //    .customTitle(newValue)
    }
    
    func getDataFromDatabase() {
        newValue = "New Value From Database"
    }
    
}

struct CustomTitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
    
    
}

#Preview {
    PreferenceKeyExample()
}
