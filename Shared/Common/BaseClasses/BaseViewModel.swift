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

    func networkRequest(_ id: T, _ request: @escaping () async throws -> Void) {
        lastRequest = id
        
        Task {
            do {
                try await request()
            }
            catch {
                await MainActor.run {
                    self.error.send(error as NSError)
                }
            }
        }
    }
}
