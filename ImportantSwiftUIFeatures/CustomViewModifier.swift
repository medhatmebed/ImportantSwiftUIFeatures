//
//  CustomViewModifier.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/20/24.
//

import SwiftUI

/// to create custom view modifier you need to create a struct that conforms to ViewModifier protocol
/// then implement the function body
struct DefaultButtonViewModifier: ViewModifier {
    let backgroundColor: Color
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
    }
}
/// extend the View to add the custom modifiers to the view modifiers list that will make the use of the custom view modifier as .customModifier
extension View {
    
    func withDefaultButtonFormatting(backgroundColor: Color = .blue) -> some View {
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
    }
    
}

struct CustomViewModifier: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .withDefaultButtonFormatting(backgroundColor: .red)
            .padding()
        
        Text("Hello")
            .modifier(DefaultButtonViewModifier(backgroundColor: .orange))
            .padding()
    }
}

#Preview {
    CustomViewModifier()
}
