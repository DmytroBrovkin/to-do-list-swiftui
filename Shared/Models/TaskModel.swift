//
//  Task.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import Foundation

struct TaskModel: Hashable, Codable, Identifiable, Comparable {
    enum State: String, Codable, Comparable {
        case todo = "to do"
        case inProgress = "in progress"
        case done = "done"

        var sortOrder: Int {
            switch self {
            case .todo: return 1
            case .inProgress: return 2
            case .done: return 3
            }
        }
        
        static func <(lhs: State, rhs: State) -> Bool {
            return lhs.sortOrder < rhs.sortOrder
        }
    }
    
    var id: Int
    var title: String
    var content: String
    var status: State
    
    static func < (lhs: TaskModel, rhs: TaskModel) -> Bool {
        return lhs.status < rhs.status
    }
}
