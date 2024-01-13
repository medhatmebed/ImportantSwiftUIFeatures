//
//  CustomPropertyWrapper.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/13/24.
//

import SwiftUI

@propertyWrapper 
struct Trimmed {
  private var value: String

  var wrappedValue: String {
    get { value.trimmingCharacters(in: .whitespacesAndNewlines) }
    set { value = newValue }
  }

  init(wrappedValue initialValue: String) {
    value = initialValue
  }
}

struct CustomPropertyWrapper: View {
    
  @Trimmed var name: String = "   John Doe   "
   

  var body: some View {
    Text("Hello, \(name)!")
  }
}

#Preview {
    CustomPropertyWrapper()
}
