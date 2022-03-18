//
//  LoginView.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import SwiftUI
import Combine

struct LoginView: View, Equatable {
    @ObservedObject private var viewModel: LoginViewModel
    @State private var isLoginComplete: Bool = false
    
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var errorHandler: ErrorHandler
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: tasksView(), isActive: $isLoginComplete) { EmptyView() }

                TextField("Email", text: $viewModel.credentials.email)
                    .defaultStyle()
                TextField("Password", text: $viewModel.credentials.password)
                    .defaultStyle()
                HStack {
                    Button("Sign in") {
                        viewModel.singIn()
                    }
                    Spacer().frame(width: 30)
                    Button("Register") {
                        viewModel.register()
                    }
                }
                .padding(.top)
            }
            .padding()
            .navigationTitle("Welcome")
            .onReceive(viewModel.result) { config in
                appState.networkConfig.token = config.token
                appState.user.email = viewModel.credentials.email

                isLoginComplete = true
            }
            .onReceive(viewModel.error) { error in
                errorHandler.handle(error: error)
            }
        }
    }
    
    private func tasksView() -> some View {
        let api = TaskAPI(authKey: appState.networkConfig.token)
        let viewModel = TasksViewModel(api: api)
        
        return TasksView(viewModel: viewModel)
                .equatable()
    }
    
    // We ignore all update from @EnvironmentObject, unless View is explicitly Binded with such @Published property.
    // This is needed to avoid View re-rendering every time @EnvironmentObject is set from any other place in the app.
    static func == (lhs: Self, rhs: Self) -> Bool {
        return true
    }
}

#if DEBUG

struct LoginView_Previews: PreviewProvider {
    @ObservedObject static private var appState = AppState()
    @ObservedObject static private var errorHandler = ErrorHandler()

    static var previews: some View {
        LoginView(viewModel: LoginViewModel(api: AuthAPI()))
            .applyErrorHandling()
            .environmentObject(appState)
            .environmentObject(errorHandler)
    }
}

#endif
