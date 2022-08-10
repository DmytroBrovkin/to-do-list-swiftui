//
//  LoginView.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import SwiftUI
import Combine

protocol LoginViewDelegate: AnyObject {
    func viewDidCompleteAuth(_ view: LoginView)
}

struct LoginView: View {
    @EnvironmentObject private var appState: AppState

    @ObservedObject private var viewModel: LoginViewModel
    @ObservedObject private var errorHandler: LoginErrorHandler

    private weak var delegate: LoginViewDelegate?
        
    init(viewModel: LoginViewModel, delegate: LoginViewDelegate) {
        self.viewModel = viewModel
        self.errorHandler = LoginErrorHandler(viewModel: viewModel)
        self.delegate = delegate
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
            
            delegate?.viewDidCompleteAuth(self)
        }
        .errorHandling($errorHandler.currentAlert)
    }
}

#if DEBUG

struct LoginView_Previews: PreviewProvider {
    @ObservedObject static private var appState = AppState()

    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel(api: AuthAPI()), delegate: AppRouter())
                .environmentObject(appState)
            LoginView(viewModel: LoginViewModel(api: AuthAPI()), delegate: AppRouter())
                .previewDevice("iPad Pro (9.7-inch)")
                .environmentObject(appState)
        }
    }
}

#endif
