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
    private var isTabbBarApproach = false
    
    func showInitialNavigationScreen() {
        let loginAPI = AuthAPI()
        let viewModel = LoginViewModel(api: loginAPI,
                                       delegate: self,
                                       appState: appState)
        let view = LoginView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        navigationController.viewControllers = [controller]
    }
    
    func showInitialTabbar() {
        isTabbBarApproach = true
        
        let factory = TabbarFactory(loginDelegate: self,
                                    tasksDelegate: self,
                                    appState: appState)
        let tabbarView = TabbarView(factory: factory)

        let controller = UIHostingController(rootView: tabbarView)
        navigationController.viewControllers = [controller]
    }
    
    private func showTasksScreen() {
        guard !isTabbBarApproach else { return }
        
        let api = TaskAPI(appState: appState)
        let viewModel = TasksViewModel(api: api, delegate: self)
        let view = TasksView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        navigationController.show(controller, sender: nil)
    }
    
    private func showTasksDetailsScreen(_ task: TaskModel?) {
        let viewModel = TasksDetailsViewModel(task: task,
                                              delegate: self,
                                              api: TaskAPI(appState: appState))
        let view = TaskDetailsView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        navigationController.show(controller, sender: nil)
    }
    
    private func popBack(_ animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
}

extension AppRouter: LoginViewModelDelegate {
    func viewModelDidCompleteAuth(_ viewModel: LoginViewModel) {
        showTasksScreen()
    }
}

extension AppRouter: TasksViewModelDelegate {
    func viewModel(_ viewModel: TasksViewModel, didSelect task: TaskModel?) {
        showTasksDetailsScreen(task)
    }
}

extension AppRouter: TaskDetailsViewModelDelegate {
    func viewModelDidCompleteTaskUpdate(_ viewModel: TasksDetailsViewModel) {
        popBack(true)
    }
}

