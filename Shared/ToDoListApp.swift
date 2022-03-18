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
    @ObservedObject var errorHandler = ErrorHandler()
    
    init() {
        errorHandler.$isAuthExpired.map { _ in UUID() }.assign(to: &appState.$rootViewId)
    }

    var body: some Scene {
        WindowGroup {
            LoginView(viewModel: LoginViewModel(api: AuthAPI()))
                // We ignore all update from @EnvironmentObject, unless View is explicitly Binded with such @Published property.
                // This is needed to avoid View re-rendering every time @EnvironmentObject is set from any other place in the app.
                // See LoginView's conformance to Equatable
                .equatable()
                .applyErrorHandling()
                .environmentObject(appState)
                .environmentObject(errorHandler)
                // This is a binding with appState.rootViewId. When it is set to any value, LoginView will be shown.
                // This is one of the way to implement `popToRootViewController() function equivalent in UIkit` 
                .id(appState.rootViewId)
                
        }
    }
}
