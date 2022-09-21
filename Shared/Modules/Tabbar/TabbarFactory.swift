//
//  TabbarFactory.swift
//  ToDoList (iOS)
//
//  Created by dmytro.brovkin on 2022-09-21.
//

import Foundation
import SwiftUI

protocol TabbarFactoryProtocol {    
    func createLoginView() -> LoginView
    func createTasksView() -> TasksView
}

class TabbarFactory: TabbarFactoryProtocol {
    private weak var loginDelegate: LoginViewModelDelegate?
    private weak var tasksDelegate: TasksViewModelDelegate?
    
    private let appState: AppState
    
    private lazy var loginViewModel: LoginViewModel = {
        return LoginViewModel(api: AuthAPI(),
                              delegate: loginDelegate!,
                              appState: appState)
    }()
    
    private lazy var tasksViewModel: TasksViewModel = {
        return TasksViewModel(api: TaskAPI(appState: appState),
                              delegate: tasksDelegate!)
    }()
    
    init(loginDelegate: LoginViewModelDelegate,
         tasksDelegate: TasksViewModelDelegate,
         appState: AppState) {
        self.loginDelegate = loginDelegate
        self.tasksDelegate = tasksDelegate
        self.appState = appState
    }
    
    func createLoginView() -> LoginView {
        return LoginView(viewModel: loginViewModel)
    }
    
    func createTasksView() -> TasksView {
        return TasksView(viewModel: tasksViewModel)
    }
}
