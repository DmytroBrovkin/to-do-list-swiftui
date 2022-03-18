//
//  AuthAPI.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Foundation
import Combine


protocol AuthAPIProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<NetworkConfig, NSError>
    func register(email: String, password: String) -> AnyPublisher<NetworkResponse, NSError>
}

class AuthAPI: APIHelper, AuthAPIProtocol {
    func signIn(email: String, password: String) -> AnyPublisher<NetworkConfig, NSError> {
        let params = [
            "email": email,
            "password": password
        ]
        
        return post(path: "auth", params: params)
    }
    
    func register(email: String, password: String) -> AnyPublisher<NetworkResponse, NSError> {
        let params = [
            "email": email,
            "password": password
           ]
        
        return post(path: "register", params: params)
    }
}
