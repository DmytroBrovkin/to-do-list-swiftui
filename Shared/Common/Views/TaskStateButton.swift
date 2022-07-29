//
//  TaskStateButton.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI

typealias TaskUpdate = (_ id: Int, _ state: TaskModel.State) -> Void

struct TaskStateButton: View {
    var task: TaskModel
    var callback: TaskUpdate
    
    var body: some View {
        Button(task.status.rawValue,
               action: {
            callback(task.id, nextState)
        })
        .buttonStyle(.borderless)
        .foregroundColor(Color.white)
        .background(bgColor)
    }
    
    var bgColor: Color {
        switch task.status {
        case .todo: return.green
        case .inProgress: return.orange
        case .done: return .red
        }
    }
    
    var nextState: TaskModel.State {
        switch task.status {
        case .todo: return .inProgress
        case .inProgress: return .done
        case .done: return .todo
        }
    }
}

#if DEBUG

struct TaskStateButton_Previews: PreviewProvider {
    @ObservedObject static private var viewModel = TasksViewModel(api: TaskAPI())

    static var previews: some View {
        TaskStateButton(task: viewModel.tasks[0]) { id, state in }
    }
}

#endif
