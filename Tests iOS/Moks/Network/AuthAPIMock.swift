//
//  AuthAPIMock.swift
//  Tests iOS
//
//  Created by Dmytro Brovkin on 2022-03-18.
//

import Foundation
@testable import ToDoList
import Combine

class AuthAPIMock: AuthAPIProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<NetworkConfig, NSError> {
        Just(NetworkConfig(token: ""))
            .setFailureType(to: NSError.self)
            .eraseToAnyPublisher()
    }
    func register(email: String, password: String) -> AnyPublisher<NetworkResponse, NSError> {
        Just(NetworkResponse(status: "ok"))
            .setFailureType(to: NSError.self)
            .eraseToAnyPublisher()
    }
}
