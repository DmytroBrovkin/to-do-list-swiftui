//
//  BaseViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-16.
//

import Foundation
import Combine
import SwiftUI

protocol BaseViewModelProtocol {
    var error: PassthroughSubject<Error, Never> { get }
}

class BaseViewModel: ObservableObject, BaseViewModelProtocol {
    @Published var currentAlert: ErrorContext?
    let error = PassthroughSubject<Error, Never>()

    @MainActor
    func networkRequest(_ request: @escaping () async throws -> Void) {
        Task {
            do {
                try await request()
            }
            catch let networkError {
                self.error.send(networkError)
                handle(networkError)
            }
        }
    }
    
    func handle(_ error: Error) {
        // implement at the super class
        currentAlert = ErrorContext(title: "Error",
                                    message: "Something went wrong. Please try again later")
    }
}
