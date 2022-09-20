//
//  LoginViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Combine
import SwiftUI

protocol LoginViewModelDelegate: AnyObject {
    func viewModelDidCompleteAuth(_ viewModel: LoginViewModel)
}

class LoginViewModel: BaseViewModel<LoginViewModel.NetworkRequest> {
    enum NetworkRequest {
        case signIn, register
    }
    
    @Published var credentials: AuthCredentials = AuthCredentials(email: "dimitri@gmail.com", password: "testtest")
    
    private let api: AuthAPIProtocol
    private weak var delegate: LoginViewModelDelegate?
    private var appState: AppState
    
    required init(api: AuthAPIProtocol,
                  delegate: LoginViewModelDelegate,
                  appState: AppState) {
        self.api = api
        self.delegate = delegate
        self.appState = appState
    }
    
    @MainActor
    func singIn() {
        networkRequest(.signIn) {
            let result = try await self.api.signIn(email: self.credentials.email, password: self.credentials.password)
            self.handle(result)
        }
    }
    
    @MainActor
    func register() {
        networkRequest(.register) {
            let _ = try await self.api.register(email: self.credentials.email, password: self.credentials.password)
            let result = try await self.api.signIn(email: self.credentials.email, password: self.credentials.password)
            self.handle(result)
        }
    }
    
    private func handle(_ result: NetworkConfig) {
        appState.networkConfig.token = result.token
        appState.user.email = credentials.email
        
        self.delegate?.viewModelDidCompleteAuth(self)
    }
    
    override func handle(_ error: NSError) {
        switch self.lastRequest {
        case .signIn:
            currentAlert = ErrorContext(title: "Error",
                                        message: "Sign in was not successful",
                                        retryAction: { [weak self] in
                guard let self = self else { return }
                Task { await self.singIn() }
            })
        case .register:
            currentAlert = ErrorContext(title: "Error",
                                        message: "Register was not successful",
                                        retryAction: { [weak self] in
                guard let self = self else { return }
                Task { await self.register() }
            })
        case .none:
            break
        }
    }
}
