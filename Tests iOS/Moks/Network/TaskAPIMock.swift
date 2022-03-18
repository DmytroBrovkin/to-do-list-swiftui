//
//  TaskAPIMock.swift
//  Tests iOS
//
//  Created by Dmytro Brovkin on 2022-03-18.
//

import Foundation
@testable import ToDoList
import Combine

class TaskAPIMock: TaskAPIProtocol {
    func fetchTasks() -> AnyPublisher<[Task], NSError> {
        let tasks: [Task] = load("Task.json")
        return Just(tasks)
                .setFailureType(to: NSError.self)
                .eraseToAnyPublisher()
    }
    
    func create(_ task: Task) -> AnyPublisher<CreateTaskResponse, NSError> {
        let tasks: [Task] = load("Task.json")
        let response = CreateTaskResponse(status: "ok",
                                          task: tasks[0])
        return Just(response)
                .setFailureType(to: NSError.self)
                .eraseToAnyPublisher()
    }
    
    func update(_ task: Task) -> AnyPublisher<NetworkResponse, NSError> {
        Just(NetworkResponse(status: "ok"))
            .setFailureType(to: NSError.self)
            .eraseToAnyPublisher()
    }
    
    func delete(_ task: Task) -> AnyPublisher<NetworkResponse, NSError> {
        Just(NetworkResponse(status: "ok"))
            .setFailureType(to: NSError.self)
            .eraseToAnyPublisher()
    }
}
