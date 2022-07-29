//
//  ToDoListApp.swift
//  Shared
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI

@main
struct ToDoListApp: App {
    @ObservedObject var appState = AppState()

    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel(api: AuthAPI()))
                .environmentObject(appState)
        }
    }
}
