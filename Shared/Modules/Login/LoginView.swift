//
//  LoginView.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import SwiftUI
import Combine

struct LoginView: View {
    @EnvironmentObject private var appState: AppState

    @ObservedObject private var viewModel: LoginViewModel
    @ObservedObject private var errorHandler: LoginErrorHandler

    private weak var router: AppRouter?
        
    init(viewModel: LoginViewModel, router: AppRouter) {
        self.viewModel = viewModel
        self.errorHandler = LoginErrorHandler(viewModel: viewModel)
        self.router = router
    }
    
    var body: some View {
        VStack {
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
        .onReceive(viewModel.networkConfig) { config in
            appState.networkConfig.token = config.token
            appState.user.email = viewModel.credentials.email
            
            router?.showTasksScreen()
        }
        .errorHandling($errorHandler.currentAlert)
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

    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel(api: AuthAPI()), router: AppRouter())
                .environmentObject(appState)
            LoginView(viewModel: LoginViewModel(api: AuthAPI()), router: AppRouter())
                .previewDevice("iPad Pro (9.7-inch)")
                .environmentObject(appState)
        }
    }
}

#endif
