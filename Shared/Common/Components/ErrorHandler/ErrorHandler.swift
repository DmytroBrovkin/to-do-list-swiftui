//
//  ErrorHandler.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-16.
//

import Foundation
import Combine

struct ErrorAlert: Identifiable {
    var id = UUID()
    var message: String
    var dismissAction: (() -> Void)?
}

class ErrorHandler: ObservableObject {
    @Published var currentAlert: ErrorAlert?
    @Published var isAuthExpired: Bool?

    func handle(error: Error, dismissAction: (() -> Void)? = nil) {
        currentAlert = ErrorAlert(message: error.localizedDescription, dismissAction: dismissAction)
    }
    
    func handle(error: NSError) {
        var description = error.localizedDescription
        
        if let dict = error.userInfo as? [String: String], let details = dict["details"] {
            description = details
        } else if let dict = error.userInfo as? [String: [String]] {
            description = dict.map { $0.0 + "=" + $0.1.joined(separator: ", ") }.joined(separator: "\n")
        }
                
        currentAlert = ErrorAlert(message: description) { [weak self] in
            switch error.code {
            case 401:
                self?.isAuthExpired = true
            default:
                break
            }
        }
    }
}
