//
//  TasksViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI
import Combine


protocol TasksViewModelDelegate: AnyObject {
    func viewModel(_ viewModel: TasksViewModel, didSelect task: TaskModel?)
}


class TasksViewModel: BaseViewModel<TasksViewModel.NetworkRequest> {
    enum NetworkRequest {
        case initial, updateTask(Int, TaskModel.State), deleteTask
    }
    
    @Published private(set) var tasks: [TaskModel] = []
    var sortedTasks: [TaskModel] { return tasks.sorted(by: { $0 < $1 }) }
    
    private var api: TaskAPIProtocol
    private weak var delegate: TasksViewModelDelegate?
    
    init(api: TaskAPIProtocol, delegate: TasksViewModelDelegate) {
        self.api = api
        self.delegate = delegate
    }
    
    @MainActor
    func loadData() {        
        networkRequest(.initial) {
            let result = try await self.api.fetchTasks()
            self.tasks = result
        }
    }
    
    @MainActor
    func update(task id: Int, state: TaskModel.State) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
       
        networkRequest(.updateTask(id, state)) {
            let currentTask = self.tasks[index]
            let targetTask = TaskModel(id: currentTask.id, title: currentTask.title, content: currentTask.content, status: state)
            
            let _ = try await self.api.update(targetTask)
            self.tasks[index] = targetTask
        }
    }
    
    func updateOrReplace(_ task: TaskModel) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            tasks.append(task)
            return
        }
        tasks[index] = task
    }
    
    @MainActor
    func delete(at indexSet: IndexSet) {
        let indexes = Array(indexSet)
        
        for index in indexes {
            let item = sortedTasks[index]
            
            networkRequest(.deleteTask) {
                let _ = try await self.api.delete(item)
                guard let targetIndex = self.tasks.firstIndex(where: { $0.id == item.id }) else { return }
                _ = self.tasks.remove(at: targetIndex)
            }
        }
    }
    
    func onSelect(_ task: TaskModel?) {
        delegate?.viewModel(self, didSelect: task)
    }
    
    override func handle(_ error: NSError) {
        guard currentAlert == nil else { return }
        
        switch self.lastRequest {
        case .initial:
            currentAlert = ErrorContext(title: "Error",
                                        message: "Tasks fetch was not successful",
                                        retryAction: { [weak self] in
                guard let self = self else { return }
                Task { await self.loadData() }
            })
        case let .updateTask(id, state):
            currentAlert = ErrorContext(title: "Error",
                                        message: "Task update was not successful",
                                        retryAction: { [weak self] in
                guard let self = self else { return }
                Task { await self.update(task: id, state: state) }
            })
        case .deleteTask:
            currentAlert = ErrorContext(title: "Error",
                                        message: "Task delete was not successful")
        case .none:
            break
        }
    }
}
