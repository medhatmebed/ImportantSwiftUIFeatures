//
//  DependencyInjectionContainer.swift
//  ImportantSwiftUIFeatures
//
//  Created by Medhat Mebed on 1/19/24.
//

import Foundation

protocol AwesomeDICProtocol {
  func register<Service>(type: Service.Type, component: Any)
  func resolve<Service>(type: Service.Type) -> Service?
}

///First of all, there are two main functions, and these two functions have an important task.
///And then, I’m going to create a Dependency Injection Container class named AwesomeDIContainer,
///and that class will have responsibilities for handling the dependencies, such as creating and holding an object.

final class AwesomeDIContainer: AwesomeDICProtocol {

///We have to make sure that our dependency injection container should be a singleton class.
///This singleton-approaching way prevents any forced use of multiple instances of the dependency injection container class and other unpredictable behavior, such as cutting some dependencies.
  static let shared = AwesomeDIContainer()

  private init() {}

///The services property is a String-Any typed dictionary that holds all services. The dictionary’s String key represents the Service’s name, and the Any value refers to Service’s instance.
///Service is a generic type. To prevent tightly coupled code, we will only use protocols. Such as UserServiceProtocol, RewardServiceProtocol, etc.(examples from the previous article)
  var services: [String: Any] = [:]

    func register<Service>(type: Service.Type, component service: Any) {
      services["\(type)"] = service
  }

  func resolve<Service>(type: Service.Type) -> Service? {
    return services["\(type)"] as? Service
  }
}

final class UserService: UserServiceProtocol {
    func fetchUsers() {
        print("Users fetching...")
    }
}

final class RewardService: RewardServiceProtocol {
    func fetchRewards() {
        print("Rewards fetching...")
    }
}

final class ViewModelDIC {

    private let userService: UserServiceProtocol
    private let rewardService: RewardServiceProtocol
///AwesomeDIContainer class provides the necessary parameters by default.
///At this point, you can be sure that you can always give the dependencies for your testing purposes or register mocked dependencies in the container.
    init(userService: UserServiceProtocol = AwesomeDIContainer.shared.resolve(type: UserServiceProtocol.self)!,
         rewardService: RewardServiceProtocol = AwesomeDIContainer.shared.resolve(type: RewardServiceProtocol.self)!) {
        self.userService = userService
        self.rewardService = rewardService
    }

//    init(userService: UserServiceProtocol, rewardService: RewardServiceProtocol) {
//        self.userService = userService
//        self.rewardService = rewardService
//    }
    
    func fetchUsers() {
        userService.fetchUsers()
    }
    
    func fetchRewards() {
        rewardService.fetchRewards()
    }

}

///And finally, we are all set to use the Dependency Injection Container class. Before calling the ViewModel class, we have to register the Services we defined.
///The Objects registration to the container will look like this:

//let container = AwesomeDIContainer.shared
//container.register(type: UserServiceProtocol.self, service: UserService())
//container.register(type: RewardServiceProtocol.self, service: RewardService())

//let viewModel = ViewModel()
//viewModel.fetchUsers()
//viewModel.fetchRewards()
