//
//  LoginViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Combine
import SwiftUI

class LoginViewModel: BaseViewModel<NetworkConfig> {
    @Published var credentials: AuthCredentials = AuthCredentials(email: "dimitri@gmail.com", password: "testtest")

    private let api: AuthAPIProtocol

    required init(api: AuthAPIProtocol) {
        self.api = api
    }
    
    func singIn() {
        let publisher = api.signIn(email: credentials.email, password: credentials.password)
        handle(publisher)
    }
    
    func register() {
        let publisher = api.register(email: credentials.email, password: credentials.password)
        handle(publisher) { [weak self] in
            self?.singIn()
        }
    }
}
