//
//  APITaskHelper.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Foundation
import Combine

protocol TaskAPIProtocol {
    func fetchTasks() -> AnyPublisher<[Task], NSError>
    func create(_ task: Task) -> AnyPublisher<CreateTaskResponse, NSError>
    func update(_ task: Task) -> AnyPublisher<NetworkResponse, NSError>
    func delete(_ task: Task) -> AnyPublisher<NetworkResponse, NSError>
}

class TaskAPI: APIHelper, TaskAPIProtocol {
    func fetchTasks() -> AnyPublisher<[Task], NSError> {
        return get(path: "task/all", params: nil)
    }
    
    func update(_ task: Task) -> AnyPublisher<NetworkResponse, NSError> {
        let params = [
            "id": "\(task.id)",
            "status": task.status.rawValue,
            "title": task.title,
            "content": task.content
        ]
        
        return post(path: "task/update", params: params)
    }
    
    func create(_ task: Task) -> AnyPublisher<CreateTaskResponse, NSError> {
        let params = [
            "status": task.status.rawValue,
            "title": task.title,
            "deadline": "2025-03-15 00:00:00",
            "content": task.content
        ]
        
        return post(path: "task", params: params)
    }
    
    func delete(_ task: Task) -> AnyPublisher<NetworkResponse, NSError> {
        let params = [
            "id": "\(task.id)"
        ]
        
        return post(path: "task/delete", params: params)
    }
}
