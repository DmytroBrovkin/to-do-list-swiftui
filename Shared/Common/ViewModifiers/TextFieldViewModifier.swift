//
//  File.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import SwiftUI

struct TextEditorStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .border(Color.gray.opacity(0.2))
            .cornerRadius(4)
    }
}


struct TextFieldStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .disableAutocorrection(true)
    }
}
