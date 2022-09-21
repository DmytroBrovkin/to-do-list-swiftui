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

class TaskAPI: APIHelper, TaskAPIProtocol {
    private let appState: AppState
    
    init(appState: AppState) {
        self.appState = appState
        super.init()
    }
    
    func fetchTasks()async throws -> [TaskModel] {
        self.authKey = appState.networkConfig.token
        return try await get(path: "task/all", params: nil)
    }
    
    func update(_ task: TaskModel) async throws -> NetworkResponse {
        self.authKey = appState.networkConfig.token
        
        let params = [
            "id": "\(task.id)",
            "status": task.status.rawValue,
            "title": task.title,
            "content": task.content
        ]
        
        return try await post(path: "task/update", params: params)
    }
    
    func create(_ task: TaskModel) async throws -> CreateTaskResponse {
        self.authKey = appState.networkConfig.token
        
        let params = [
            "status": task.status.rawValue,
            "title": task.title,
            "deadline": "2025-03-15 00:00:00",
            "content": task.content
        ]
        
        return try await post(path: "task", params: params)
    }
    
    func delete(_ task: TaskModel) async throws -> NetworkResponse {
        self.authKey = appState.networkConfig.token
        
        let params = [
            "id": "\(task.id)"
        ]
        
        return try await post(path: "task/delete", params: params)
    }
}
