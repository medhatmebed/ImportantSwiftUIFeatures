//
//  CustomPropertyWrapper.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/13/24.
//

import SwiftUI

/// property wrapper is a feature for SwiftUI that adds new behavior to the properties
@propertyWrapper
struct Trimmed {
  private var value: String
/// inorder to create property wrapper you have to implement wrappedValue
  var wrappedValue: String {
    get { value.trimmingCharacters(in: .whitespacesAndNewlines) }
    set { value = newValue }
  }

  init(wrappedValue initialValue: String) {
    value = initialValue
  }
}

struct CustomPropertyWrapper: View {
    /// we can see here that @Trimmed property wrapper added a new behavior to the name property
  @Trimmed var name: String = "   John Doe   "
   

  var body: some View {
    Text("Hello, \(name)!")
  }
}

#Preview {
    CustomPropertyWrapper()
}
