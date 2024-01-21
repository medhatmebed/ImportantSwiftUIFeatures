//
//  ViewBuilderExample.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/21/24.
//

import SwiftUI


struct HeaderViewRegular: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("title")
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text("Description")
                .font(.callout)
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}

struct HeaderViewGeneric<Content: View>: View {
    let title: String
    let content: Content
    ///@viewbuilder in the initializer
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, content: {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            content
            
            RoundedRectangle(cornerRadius: 5)
                .frame(height: 2)
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }
}


struct ViewBuilderExample: View {
    var body: some View {
        HeaderViewRegular()
        ///here in the closure we can build multiple views
        HeaderViewGeneric(title: "Header Generic") {
            Text("this is the generic header")
        }
        Spacer()
    }
}

#Preview {
    LocalViewBuilder(type: .two)
}


struct LocalViewBuilder: View {
    
    enum ViewType {
        case one, two, three
    }
    let type: ViewType
    
    var body: some View {
        VStack {
            headerView
        }
    }
    ///we can see here because we are returning multiple views
    @ViewBuilder private var headerView: some View {
            switch type {
            case .one:
                viewOne
            case .two:
             viewTwo
            case .three:
               viewThree
            }
    }
    
    private var viewOne: some View {
        Text("One!")
    }
    ///viewbuilders is often used to define functions or properties that return multiple views, making code more concise and readable.
    @ViewBuilder private var viewTwo: some View {
       // VStack {
            Text("Two")
             Image(systemName: "heart.fill")
       // }
    }
    private var viewThree: some View {
        Image(systemName: "heart.fill")
    }
    
}
