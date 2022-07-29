//
//  TaskAPIMock.swift
//  Tests iOS
//
//  Created by Dmytro Brovkin on 2022-03-18.
//

import Foundation
import Combine

class TaskAPIMock: TaskAPIProtocol {
    func fetchTasks() async throws -> [TaskModel] {
        return load("Task.json")
    }
    
    func create(_ task: TaskModel) async throws -> CreateTaskResponse {
        let tasks: [TaskModel] = load("Task.json")
        return CreateTaskResponse(status: "ok",
                                  task: tasks[0])
    }
    
    func update(_ task: TaskModel) async throws -> NetworkResponse {
        return NetworkResponse(status: "ok")
    }
    
    func delete(_ task: TaskModel) async throws -> NetworkResponse {
        return NetworkResponse(status: "ok")
    }
}
