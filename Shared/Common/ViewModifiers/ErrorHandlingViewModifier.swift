//
//  ErrorHandlingViewModifier.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-16.
//

import Foundation
import SwiftUI
import Combine

struct ErrorHandlingViewModifier: ViewModifier {
    @EnvironmentObject private var errorHandler: ErrorHandler

    func body(content: Content) -> some View {
        content
            .alert(item: $errorHandler.currentAlert) { currentAlert in
                Alert(title: Text("Error"),
                      message: Text(currentAlert.message),
                      dismissButton: .default(Text("Ok")) {
                        currentAlert.dismissAction?()
                     }
                )
            }
    }
}

extension View {
    func applyErrorHandling() -> some View {
        modifier(ErrorHandlingViewModifier())
    }
}
