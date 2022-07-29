//
//  TaskDetailsViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-14.
//

import Foundation
import Combine

class TasksDetailsViewModel: BaseViewModel<TasksDetailsViewModel.NetworkRequest> {
    enum NetworkRequest {
        case submit
    }
    
    enum Strategy {
        case update, create
    }
    
    @Published var task: TaskModel
    let submitCompleted = PassthroughSubject<Bool, Never>()
    
    private var subscribers = Set<AnyCancellable>()
    private var strategy: Strategy
    private var api: TaskAPIProtocol
    
    init(task: TaskModel?, api: TaskAPIProtocol) {
        self.api = api
        
        if let task = task {
            self.task = task
            self.strategy = .update
            return
        }
        
        self.task = TaskModel(id: Int.random(in: 1...10000), title: "", content: "", status: .todo)
        self.strategy = .create
    }
    
    func update(task id: Int, status: TaskModel.State) {
        task.status = status
    }
    
    func submit() {
        switch strategy {
        case .update:
            updateTask()
        case .create:
            createTask()
        }
    }
    
    private func updateTask() {
        networkRequest(.submit) {
            let _ = try await self.api.update(self.task)
        }
    }
    
    private func createTask() {
        networkRequest(.submit) {
            let _ = try await self.api.create(self.task)
            await MainActor.run { self.submitCompleted.send(true) }
        }
    }
}

