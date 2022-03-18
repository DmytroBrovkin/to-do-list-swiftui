//
//  TextField.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import SwiftUI

extension TextEditor {
    func defaultStyle() -> some View {
        modifier(TextEditorStyle())
    }
}

extension TextField {
    func defaultStyle() -> some View {
        modifier(TextFieldStyle())
    }
}
