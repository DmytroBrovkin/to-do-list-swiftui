//
//  TaskView.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI

struct TaskDetailsView: View {
    @ObservedObject private var errorHandler: ErrorHandler<TasksDetailsViewModel>
    @ObservedObject private var viewModel: TasksDetailsViewModel
    
    private weak var router: AppRouter?
    
    init(viewModel: TasksDetailsViewModel, router: AppRouter) {
        self.viewModel = viewModel
        self.errorHandler = ErrorHandler(viewModel: viewModel)
        self.router = router
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
        .onReceive(viewModel.submitCompleted) { _ in
            router?.popBack(true)
        }
        .onReceive(viewModel.error) { error in
            errorHandler.handle(error: error)
        }
        .padding()
        .navigationTitle("Add task")
        .errorHandling($errorHandler.currentAlert)

        Button("Submit") {
            viewModel.submit()
        }
        Spacer()
    }
}

#if DEBUG

struct TaskDetailsView_Previews: PreviewProvider {
    @ObservedObject static private var appState = AppState()
    static private let tasks: [TaskModel] = load("Task.json")

    static var previews: some View {
        TaskDetailsView(viewModel: TasksDetailsViewModel(task: tasks[0], api: TaskAPIMock()),
                        router: AppRouter())
    }
}

#endif
