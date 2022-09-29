//
//  APITaskHelper.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Foundation
import Combine

protocol TaskAPIProtocol {
    func fetchTasks() async throws -> [TaskModel]
    func create(_ task: TaskModel) async throws -> CreateTaskResponse
    func update(_ task: TaskModel) async throws -> NetworkResponse
    func delete(_ task: TaskModel) async throws -> NetworkResponse
}

enum TaskAPIErrors: Error {
    case fetchTaskFfailed, updateTaskFailed(TaskModel), createTaskFailed(TaskModel), deleteTaskFailed(TaskModel)
}

class TaskAPI: APIHelper, TaskAPIProtocol {
    private let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
    }
    
    func fetchTasks()async throws -> [TaskModel] {
        self.authKey = appState.networkConfig.token
        
        let dtm = DynatraceEvent("Fetch tasks event")
        return try await get(path: "task/all", params: nil, dtmEvent: dtm, error: TaskAPIErrors.fetchTaskFfailed)
    }
    
    func update(_ task: TaskModel) async throws -> NetworkResponse {
        self.authKey = appState.networkConfig.token
        
        let params = [
            "id": "\(task.id)",
            "status": task.status.rawValue,
            "title": task.title,
            "content": task.content
        ]
        
         let dtm = DynatraceEvent("Update task event")
        return try await post(path: "task/update", params: params, dtmEvent: dtm, error: TaskAPIErrors.updateTaskFailed(task))
    }
    
    func create(_ task: TaskModel) async throws -> CreateTaskResponse {
        self.authKey = appState.networkConfig.token
        
        let params = [
            "status": task.status.rawValue,
            "title": task.title,
            "deadline": "2025-03-15 00:00:00",
            "content": task.content
        ]
        
        let dtm = DynatraceEvent("Update task event")
        return try await post(path: "task", params: params, dtmEvent: dtm, error: TaskAPIErrors.createTaskFailed(task))
    }
    
    func delete(_ task: TaskModel) async throws -> NetworkResponse {
        self.authKey = appState.networkConfig.token
        
        let params = [
            "id": "\(task.id)"
        ]
        
        let dtm = DynatraceEvent("Update task event")
        return try await post(path: "task/delete", params: params, dtmEvent: dtm, error: TaskAPIErrors.deleteTaskFailed(task))
    }
}
