//
//  LoginView.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import SwiftUI
import Combine

struct LoginView: View {
    @ObservedObject private var viewModel: LoginViewModel
        
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
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
        .errorHandling($viewModel.currentAlert)
    }
}

#if DEBUG

struct LoginView_Previews: PreviewProvider {
    @ObservedObject static private var appState = AppState()

    static var previews: some View {
        Group {
            LoginView(viewModel: LoginViewModel(api: AuthAPI(), delegate: AppRouter(), appState: appState))
            LoginView(viewModel: LoginViewModel(api: AuthAPI(), delegate: AppRouter(), appState: appState))
                .previewDevice("iPad Pro (9.7-inch)")
        }
    }
}

#endif
