//
//  TaskRow.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI

struct TaskRow: View {
    var task: Task
    var callback: TaskUpdate

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(task.title)
                    .font(.headline)
                Spacer()
                TaskStateButton(task: task, callback: self.callback)
            }
            Text(task.content)
                .font(.caption)
            
        }
    }
}


#if DEBUG

struct TaskRow_Previews: PreviewProvider {
    @ObservedObject static private var viewModel = TasksViewModel(api: TaskAPI())
    
    static var previews: some View {
        TaskRow(task: viewModel.tasks[0]) { id, state in }
            .previewLayout(.fixed(width: 300, height: 70))
    }
}

#endif
