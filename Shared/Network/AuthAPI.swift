//
//  AuthAPI.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Foundation
import Combine


protocol AuthAPIProtocol {
    func signIn(email: String, password: String) async throws -> NetworkConfig
    func register(email: String, password: String) async throws -> NetworkResponse
}

class AuthAPI: APIHelper, AuthAPIProtocol {
    func signIn(email: String, password: String) async throws -> NetworkConfig {
        let params = [
            "email": email,
            "password": password
        ]
        
        return try await post(path: "auth", params: params)
    }
    
    func register(email: String, password: String) async throws -> NetworkResponse {
        let params = [
            "email": email,
            "password": password
           ]
        
        return try await post(path: "register", params: params)
    }
}
