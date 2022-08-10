//
//  AppRouter.swift
//  ToDoList (iOS)
//
//  Created by dmytro.brovkin on 2022-07-29.
//

import Foundation
import UIKit
import SwiftUI

class AppRouter {
    let navigationController = UINavigationController()
    @ObservedObject var appState = AppState()
    
    func showInitialScreen() {
        let loginAPI = AuthAPI()
        let viewModel = LoginViewModel(api: loginAPI)
        let view = LoginView(viewModel: viewModel, delegate: self)
            .environmentObject(appState)
        
        let controller = UIHostingController(rootView: view)
        navigationController.viewControllers = [controller]
    }
    
    private func showTasksScreen() {
        let api = TaskAPI(authKey: appState.networkConfig.token)
        let viewModel = TasksViewModel(api: api)
        let view = TasksView(viewModel: viewModel, delegate: self)
        
        let controller = UIHostingController(rootView: view)
        navigationController.show(controller, sender: nil)
    }
    
    private func showTasksDetailsScreen(_ task: TaskModel?) {
        let viewModel = TasksDetailsViewModel(task: task, api: TaskAPI(authKey: appState.networkConfig.token))
        let view = TaskDetailsView(viewModel: viewModel, delegate: self)
        
        let controller = UIHostingController(rootView: view)
        navigationController.show(controller, sender: nil)
    }
    
    private func popBack(_ animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}


extension AppRouter: LoginViewDelegate {
    func viewDidCompleteAuth(_ view: LoginView) {
        showTasksScreen()
    }
}

extension AppRouter: TasksViewDelegate {
    func view(_ view: TasksView, didSelect task: TaskModel?) {
        showTasksDetailsScreen(task)
    }
}

extension AppRouter: TaskDetailsViewDelegate {
    func viewDidCompleteTaskUpdate(_ view: TaskDetailsView) {
        popBack(true)
    }
}
