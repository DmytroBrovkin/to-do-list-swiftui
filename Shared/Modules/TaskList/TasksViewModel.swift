//
//  TasksViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI
import Combine

class TasksViewModel: BaseViewModel<TasksViewModel.NetworkRequest> {
    enum NetworkRequest {
        case initial, updateTask(Int, TaskModel.State), deleteTask
    }
    
    @Published private(set) var tasks: [TaskModel] = []
    var sortedTasks: [TaskModel] { return tasks.sorted(by: { $0 < $1 }) }
    
    private var api: TaskAPIProtocol
    
    init(api: TaskAPIProtocol) {
        self.api = api
    }
    
    func loadData() {        
        networkRequest(.initial) {
            let result = try await self.api.fetchTasks()
            await MainActor.run { self.tasks = result }
        }
    }
    
    func update(task id: Int, state: TaskModel.State) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
       
        networkRequest(.updateTask(id, state)) {
            let currentTask = self.tasks[index]
            let targetTask = TaskModel(id: currentTask.id, title: currentTask.title, content: currentTask.content, status: state)
            
            let _ = try await self.api.update(targetTask)
            await MainActor.run { self.tasks[index] = targetTask }
        }
    }
    
    func updateOrReplace(_ task: TaskModel) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            tasks.append(task)
            return
        }
        tasks[index] = task
    }
    
    func delete(at indexSet: IndexSet) {
        let indexes = Array(indexSet)
        
        for index in indexes {
            let item = sortedTasks[index]
            
            networkRequest(.deleteTask) {
                let _ = try await self.api.delete(item)
                guard let targetIndex = self.tasks.firstIndex(where: { $0.id == item.id }) else { return }
                await MainActor.run { _ = self.tasks.remove(at: targetIndex) }
            }
        }
    }
}
