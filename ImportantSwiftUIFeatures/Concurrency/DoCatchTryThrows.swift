//
//  DoCatchTryThrows.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/18/24.
//

import SwiftUI

enum CredentialErrors: Error {
    case badUserName
    case badPassword
}

class DoCatchTryThrowsDataService {
    
    let isActive = true
    
    func getTitile() -> (title: String?, error: Error?) {
        if isActive {
            return ("New Text!!!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New Text!!!")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    /// using throws keyword meaning that this function might throw an error
    /// and when you call this function you have to call it within do catch block and using "try"
    /// there's a difference between try and try? "try" meaning that you guarantee the return type and if it throws and error you will catch it. but if you use "try?" meaning that you don't care about the error and the return type with be an optional type
    func getTitle3() throws -> String {
        if isActive {
            return "New Text!!!"
        } else {
            throw URLError(.badURL)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final Text!!!"
        } else {
            throw URLError(.badURL)
        }
    }
    
    func validateCredentials(userName: String, password: String) throws {
        
        if userName.count < 4 {
            throw CredentialErrors.badUserName
        }
        /// here we're checking if the password contains at least one decimal character
        if (password.rangeOfCharacter(from: NSCharacterSet.decimalDigits) == nil) {
            throw CredentialErrors.badPassword
        }
    }
    
}

class DoCatchTryThrowsViewModel: ObservableObject {
    
    @Published var text = "Starting Text."
    let manager = DoCatchTryThrowsDataService()
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitile()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
        */
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        do {
            /// notice here we used try and try?
//            let newTitle = try manager.getTitle3()
//            self.text = newTitle
            if let newTitle = try? manager.getTitle3() {
                self.text = newTitle
            }
            let finalText = try manager.getTitle4()
            self.text = finalText
            
        } catch {
            self.text = error.localizedDescription
        }
        
        do {
            try manager.validateCredentials(userName: "medhat", password: "medhat")
        } catch {
            switch error {
            case CredentialErrors.badUserName:
                print("user name too short")
            case CredentialErrors.badPassword:
                print("Passord doesn't contain decimal number")
            default:
                break
            }
        }
        
    }
    
}

struct DoCatchTryThrows: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrows()
}
