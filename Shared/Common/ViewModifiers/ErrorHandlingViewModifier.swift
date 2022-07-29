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
    @Binding var context: ErrorContext?

    func body(content: Content) -> some View {
        switch context?.type {
        case .alert:
            content
                .alert(item: $context) { currentAlert in
                    if currentAlert.retryAction != nil {
                        return Alert(title: Text(currentAlert.title),
                                     message: Text(currentAlert.message),
                                     primaryButton: .default(Text("Ok")),
                                     secondaryButton: .default(Text("Retry"), action: currentAlert.retryAction))
                    } else {
                        return Alert(title: Text(currentAlert.title),
                              message: Text(currentAlert.message),
                              dismissButton: .default(Text("Ok"))
                        )
                    }
                }
        case .errorScreen:
            // To be implemented
            content
        case .none:
            content
        }
    }
}

extension View {
    func errorHandling(_ context: Binding<ErrorContext?>) -> some View {
        modifier(ErrorHandlingViewModifier(context: context))
    }
}
