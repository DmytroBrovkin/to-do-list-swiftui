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
            }
        }
    }
}
