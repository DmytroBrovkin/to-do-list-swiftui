//
//  TaskView.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI

struct TaskDetailsView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var errorHandler: ErrorHandler
    @ObservedObject private var viewModel: TasksDetailsViewModel
    
    @Environment(\.dismiss) private var dismiss
    private var callback: (Task) -> Void
    
    init(viewModel: TasksDetailsViewModel, callback: @escaping (Task) -> Void) {
        self.viewModel = viewModel
        self.callback = callback
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                TextField("Task title here", text: $viewModel.task.title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.headline)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                Spacer()
                TaskStateButton(task: viewModel.task) { id, status in
                    viewModel.update(task: id, status: status)
                }
            }
            ZStack(alignment: .topLeading) {
                TextEditor(text: $viewModel.task.content)
                    .defaultStyle()
                    .frame(maxHeight: 200)
                    .disableAutocorrection(true)
                    
                if viewModel.task.content == "" {
                    Text("Task description here")
                        .opacity(0.5)
                        .allowsHitTesting(false)
                        .offset(x: 5, y: 10)
                }
            }
        }
        .onReceive(viewModel.result) { config in
            callback(viewModel.task)
            DispatchQueue.main.async { dismiss() }
        }
        .onReceive(viewModel.error) { error in
            errorHandler.handle(error: error)
        }
        .padding()
        .navigationTitle("Add task")
        
        Button("Submit") {
            viewModel.submit()
        }
        Spacer()
    }
}

#if DEBUG

struct TaskDetailsView_Previews: PreviewProvider {
    @ObservedObject static private var appState = AppState()
    @ObservedObject static private var errorHandler = ErrorHandler()
    static private let tasks: [Task] = load("Task.json")

    static var previews: some View {
        TaskDetailsView(viewModel: TasksDetailsViewModel(task: tasks[0], api: TaskAPIMock())) { task in }
            .applyErrorHandling()
            .environmentObject(appState)
            .environmentObject(errorHandler)
    }
}

#endif
