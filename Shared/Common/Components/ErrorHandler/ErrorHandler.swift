//
//  ErrorHandler.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-16.
//

import Foundation
import Combine

struct ErrorContext: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let type: `Type` = .alert
    var dismissAction: (() -> Void)?
    var retryAction: (() -> Void)?
    
    enum `Type` {
        case alert, errorScreen
    }
}

class ErrorHandler<T: BaseViewModelProtocol>: ObservableObject  {
    @Published var currentAlert: ErrorContext?
    var disposables = Set<AnyCancellable>()
    
    let viewModel: T

    init(viewModel: T) {
        self.viewModel = viewModel
        self.viewModel.error
            .sink(receiveValue: handle(error:))
            .store(in: &disposables)
    }
    
    func handle(error: NSError) {
        currentAlert = ErrorContext(title: "Error",
                                    message: "Something went wrong. Please try again later")
    }
}
