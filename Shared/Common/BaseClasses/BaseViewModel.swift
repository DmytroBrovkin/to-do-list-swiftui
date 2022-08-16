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
    var error: PassthroughSubject<NSError, Never> { get }
}

class BaseViewModel<T>: ObservableObject, BaseViewModelProtocol {
    @Published var currentAlert: ErrorContext?
    
    let error = PassthroughSubject<NSError, Never>()
    var lastRequest: T?

    @MainActor
    func networkRequest(_ id: T, _ request: @escaping () async throws -> Void) {
        Task {
            do {
                try await request()
            }
            catch {
                lastRequest = id
                self.error.send(error as NSError)
                handle(error as NSError)
            }
        }
    }
    
    
    func handle(_ error: NSError) {
        // implement at the super class
        currentAlert = ErrorContext(title: "Error",
                                    message: "Something went wrong. Please try again later")
    }
}
