//
//  NetworkModels.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-16.
//

import Foundation

struct NetworkConfig: Codable {
    var token: String
}

struct AuthCredentials: Codable {
    var email: String
    var password: String
}

struct NetworkResponse: Codable {
    let status: String
}

struct CreateTaskResponse: Codable {
    let status: String
    let task: TaskModel
}
