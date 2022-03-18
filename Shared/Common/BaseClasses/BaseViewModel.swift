//
//  BaseViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-16.
//

import Foundation
import Combine
import SwiftUI

class BaseViewModel<T: Codable>: ObservableObject {
    let result = PassthroughSubject<T, Never>()
    let error = PassthroughSubject<NSError, Never>()

    var disposables = Set<AnyCancellable>()

    func handle(_ publisher: AnyPublisher<T, NSError>) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
              receiveCompletion: { [weak self] value in
                switch value {
                case let .failure(error):
                    self?.error.send(error)
                default:
                    break
                }
              },
              receiveValue: { [weak self] value in
                  self?.result.send(value)
            })
            .store(in: &disposables)
    }
    
    func handle<T: Codable>(_ publisher: AnyPublisher<T, NSError>, _ callback: @escaping (T) -> Void) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
              receiveCompletion: { [weak self] value in
                switch value {
                case let .failure(error):
                    self?.error.send(error)
                default:
                    break
                }
              },
              receiveValue: { value in
                  callback(value)
            })
            .store(in: &disposables)
    }
    
    func handle(_ publisher: AnyPublisher<NetworkResponse, NSError>, _ callback: @escaping () -> Void) {
        publisher
            .receive(on: DispatchQueue.main)
            .sink(
              receiveCompletion: { [weak self] value in
                switch value {
                case let .failure(error):
                    self?.error.send(error)
                default:
                    break
                }
              },
              receiveValue: { value in
                  guard value.status == "ok" else { self.error.send(.badServerResponse); return }
                  callback()
            })
            .store(in: &disposables)
    }
}
