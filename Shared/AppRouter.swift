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
        let view = LoginView(viewModel: viewModel, router: self)
            .environmentObject(appState)
        
        let controller = UIHostingController(rootView: view)
        navigationController.viewControllers = [controller]
    }
    
    func showTasksScreen() {
        let api = TaskAPI(authKey: appState.networkConfig.token)
        let viewModel = TasksViewModel(api: api)
        let view = TasksView(viewModel: viewModel, router: self)
        
        let controller = UIHostingController(rootView: view)
        navigationController.show(controller, sender: nil)
    }
    
    func showTasksDetailsScreen(_ task: TaskModel?) {
        let viewModel = TasksDetailsViewModel(task: task, api: TaskAPI(authKey: appState.networkConfig.token))
        let view = TaskDetailsView(viewModel: viewModel, router: self)
        
        let controller = UIHostingController(rootView: view)
        navigationController.show(controller, sender: nil)
    }
    
    func popBack(_ animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}
