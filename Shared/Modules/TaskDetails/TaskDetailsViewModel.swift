//
//  TaskDetailsViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-14.
//

import Foundation
import Combine

class TasksDetailsViewModel: BaseViewModel<NetworkResponse> {
    enum Strategy {
        case update, create
    }
    
    @Published var task: Task

    private var subscribers = Set<AnyCancellable>()
    private var strategy: Strategy
    private var api: TaskAPIProtocol
    
    init(task: Task?, api: TaskAPIProtocol) {
        self.api = api
        
        if let task = task {
            self.task = task
            self.strategy = .update
            return
        }
        
        self.task = Task(id: Int.random(in: 1...10000), title: "", content: "", status: .todo)
        self.strategy = .create
    }
    
    func update(task id: Int, status: Task.State) {
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
        let publisher = api.update(task)
        handle(publisher)
    }
    
    private func createTask() {
        let publisher = api.create(task)
            .map { [weak self] response -> NetworkResponse in
                guard let self = self else { return NetworkResponse(status: response.status) }
                self.task.id = response.task.id
                return NetworkResponse(status: response.status)
            }
            .eraseToAnyPublisher()
        
        handle(publisher)
    }
}

