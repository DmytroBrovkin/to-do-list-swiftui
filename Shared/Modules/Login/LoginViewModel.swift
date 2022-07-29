//
//  LoginViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Combine
import SwiftUI

class LoginViewModel: BaseViewModel<LoginViewModel.NetworkRequest> {
    enum NetworkRequest {
        case signIn, register
    }
    
    @Published var credentials: AuthCredentials = AuthCredentials(email: "dimitri@gmail.com", password: "testtest")
    let networkConfig = PassthroughSubject<NetworkConfig, Never>()
    
    private let api: AuthAPIProtocol

    required init(api: AuthAPIProtocol) {
        self.api = api
    }
    
    func singIn() {
        networkRequest(.signIn) {
            let result = try await self.api.signIn(email: self.credentials.email, password: self.credentials.password)
            await MainActor.run { self.networkConfig.send(result) }
        }
    }
    
    func register() {
        networkRequest(.register) {
            let _ = try await self.api.register(email: self.credentials.email, password: self.credentials.password)
            let result = try await self.api.signIn(email: self.credentials.email, password: self.credentials.password)
            await MainActor.run { self.networkConfig.send(result) }
        }
    }
}
