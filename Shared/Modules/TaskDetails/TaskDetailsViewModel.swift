//
//  TaskDetailsViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-14.
//

import Foundation
import Combine

protocol TaskDetailsViewModelDelegate: AnyObject {
    func viewModelDidCompleteTaskUpdate(_ viewModel: TasksDetailsViewModel)
}

class TasksDetailsViewModel: BaseViewModel {
    enum Strategy {
        case update, create
    }
    
    @Published var task: TaskModel
    
    private var strategy: Strategy
    private let subscribers = Set<AnyCancellable>()
    private let api: TaskAPIProtocol
    private weak var delegate: TaskDetailsViewModelDelegate?
    
    init(task: TaskModel?,
         delegate: TaskDetailsViewModelDelegate,
         api: TaskAPIProtocol) {
        self.api = api
        self.delegate = delegate
        
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
    
    @MainActor
    func submit() {
        switch strategy {
        case .update:
            updateTask()
        case .create:
            createTask()
        }
    }
    
    @MainActor
    private func updateTask() {
        networkRequest {
            let _ = try await self.api.update(self.task)
        }
    }
    
    @MainActor
    private func createTask() {
        networkRequest {
            let _ = try await self.api.create(self.task)
            self.delegate?.viewModelDidCompleteTaskUpdate(self)
        }
    }
}

