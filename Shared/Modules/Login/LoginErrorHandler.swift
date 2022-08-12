//
//  LoginErrorHandler.swift
//  ToDoList (iOS)
//
//  Created by dmytro.brovkin on 2022-07-29.
//

import Foundation

class LoginErrorHandler: ErrorHandler<LoginViewModel> {
    override func handle(error: NSError) {
        switch viewModel.lastRequest {
        case .signIn:
            currentAlert = ErrorContext(title: "Error",
                                        message: "Sign in was not successful",
                                        retryAction: { [weak self] in
                guard let self = self else { return }
                Task { await self.viewModel.singIn() }
            })
        case .register:
            currentAlert = ErrorContext(title: "Error",
                                        message: "Register was not successful",
                                        retryAction: { [weak self] in
                guard let self = self else { return }
                Task { await self.viewModel.register() }
            })
        case .none:
            break
        }
    }
}
