//
//  Enums.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/18/24.
//

import Foundation

enum Day: String {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
}
enum TrafficLight {
    case red
    case yellow
    case green

    func next() -> TrafficLight {
        switch self {
        case .red: return .green
        case .yellow: return .red
        case .green: return .yellow
        }
    }
}
enum PizzaSize: String {
    case small = "8 inches"
    case medium = "12 inches"
    case large = "16 inches"

    func price() -> Double {
        switch self {
        case .small: return 8.99
        case .medium: return 12.99
        case .large: return 15.99
        }
    }
}
/// here is example of how to use Day enum
//let today = Day.tuesday
//print(today) // Output: "tuesday"
//
//if today == .friday {
//    print("TGIF!")
//}

/// here is example how to use TrafficLight enum
//var currentLight = TrafficLight.red
//currentLight = currentLight.next()
//print(currentLight) // Output: "green"


/// we can use enums with associated values which means that we can pass data into the cases
enum TemperatureUnit {
case celsius(Double)
case fahrenheit(Double)
}

enum HttpMethod {
case get
case post(data: Data)
case put(data: Data)
case delete
}

enum Credentials {
case usernamePassword(username: String, password: String)
case token(String)
}

/// Creating Instances with Associated Values: you have to pass the values
//let currentTemp = TemperatureUnit.celsius(25.0)
//let request = HttpMethod.post(data: someData)
//let loginMethod = Credentials.usernamePassword(username: "johndoe", password: "secret123")

/// Accessing Associated Values: Use a switch statement to access the associated values based on the enum case:
//switch currentTemp {
//case .celsius(let value):
//    print("It's \(value) degrees Celsius.")
//case .fahrenheit(let value):
//    print("It's \(value) degrees Fahrenheit.")
//}
//
//switch request {
//case .post(let data):
//    // Process the post request with data
//default:
//    // Handle other request types
//}


///KeyPoints:
///Associated values enhance enums by allowing them to store additional information tailored to each case.
///They make enums more versatile and expressive, enabling you to model more complex data structures.
///Each enum case can have its unique associated value type, providing flexibility in data representation.
///Access associated values using a switch statement to handle different cases and their associated data.
