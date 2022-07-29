//
//  TasksErrorHandler.swift
//  ToDoList (iOS)
//
//  Created by dmytro.brovkin on 2022-07-29.
//

import Foundation

class TasksErrorHandler: ErrorHandler<TasksViewModel> {
    override func handle(error: NSError) {
        guard currentAlert == nil else { return }
        
        switch viewModel.lastRequest {
        case .initial:
            currentAlert = ErrorContext(title: "Error",
                                        message: "Tasks fetch was not successful",
                                        retryAction: { [weak self] in
                guard let self = self else { return }
                self.viewModel.loadData()
            })
        case let .updateTask(id, state):
            currentAlert = ErrorContext(title: "Error",
                                        message: "Task update was not successful",
                                        retryAction: { [weak self] in
                guard let self = self else { return }
                self.viewModel.update(task: id, state: state)
            })
        case .deleteTask:
            currentAlert = ErrorContext(title: "Error",
                                        message: "Task delete was not successful")
        case .none:
            break
        }
    }
}
