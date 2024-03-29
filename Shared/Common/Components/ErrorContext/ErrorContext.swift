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
