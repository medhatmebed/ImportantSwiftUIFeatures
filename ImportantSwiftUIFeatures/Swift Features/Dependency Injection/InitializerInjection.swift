//
//  InitializerInjection.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/19/24.
//

import Foundation

/// Dependency Injection iis a 25$ term for 5 cent concept
/// Dependency Injection is a software design pattern that allows you to use a technique in which an object receives other objects that it depends on. These other objects are called dependencies.
///

protocol UserServiceProtocol {
    func fetchUsers()
}

protocol RewardServiceProtocol {
    func fetchRewards()
}
/// the receiver "THE CLIENT"
/// in this example we use initializer injection
final class ViewModelDI {
/// "DEPENDENCIES"
    private let userService: UserServiceProtocol
    private let rewardService: RewardServiceProtocol
/// "INJECTOR" Initializer Injection
    init(userService: UserServiceProtocol, rewardService: RewardServiceProtocol) {
        self.userService = userService
        self.rewardService = rewardService
    }

}

/// Another dependencies injection way is Setter Injection(a.k.a Property Injection).
final class ViewModelDI2 {
/// notice here we can make our dependencies optional and we set each one separately
/// This can be a pretty easy way to implement, but it’s easy to forget to inject a required dependency since these are optional.
    private var userService: UserServiceProtocol?
    private var rewardService: RewardServiceProtocol?

    func setUserService(userService: UserServiceProtocol) {
        self.userService = userService
    }

    func setRewardService(rewardService: RewardServiceProtocol) {
        self.rewardService = rewardService
    }

}

/// Another dependencies injection way is Interface Injection follows this way; the client conforms to protocols used to inject dependencies.
/// here we create a protocol to be responsible for passing the dependencies
protocol ServiceProtocol {
    func users(service: UserServiceProtocol)
    func rewards(service: RewardServiceProtocol)
}

final class ViewModelDI3: ServiceProtocol {
    /// notice here we create dependencies as optionals and then we conform to protocol and implements its required functions
    ///  in these required functions we pass our dependencies
    private var userService: UserServiceProtocol?
    private var rewardService: RewardServiceProtocol?
    
    func users(service: UserServiceProtocol) {
        self.userService = service
    }
    
    func rewards(service: RewardServiceProtocol) {
        self.rewardService = service
    }
    
}
