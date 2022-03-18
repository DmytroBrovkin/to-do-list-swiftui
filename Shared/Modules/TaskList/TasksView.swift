//
//  ContentView.swift
//  Shared
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI

struct TasksView: View, Equatable {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var errorHandler: ErrorHandler
    @ObservedObject private var viewModel: TasksViewModel
    
    init(viewModel: TasksViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        List {
            ForEach(viewModel.sortedTasks, id: \.id) { task in
                NavigationLink(destination: createTaskDetailsView(task)) {
                    TaskRow(task: task) { id, state in
                        viewModel.update(task: id, state: state)
                    }
                }
            }.onDelete(perform: viewModel.delete(at:))
        }
        .onReceive(viewModel.error) { error in
            errorHandler.handle(error: error)
        }
        .onAppear(perform: viewModel.loadData)
        .navigationTitle("To do list")
        .toolbar {
            NavigationLink(destination: createTaskDetailsView(nil)) {
                Text("Add")
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private func createTaskDetailsView(_ task: Task?) -> some View {
        let targetViewModel = TasksDetailsViewModel(task: task, api: TaskAPI(authKey: appState.networkConfig.token))
        let targetView = TaskDetailsView(viewModel: targetViewModel) { task in
            viewModel.updateOrReplace(task)
        }

        return targetView
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return true
    }
}

#if DEBUG

struct TasksView_Previews: PreviewProvider {
    @ObservedObject static private var appState = AppState()
    @ObservedObject static private var errorHandler = ErrorHandler()
    
    static var previews: some View {
        NavigationView {
            TasksView(viewModel: TasksViewModel(api: TaskAPIMock()))
                .applyErrorHandling()
                .environmentObject(appState)
                .environmentObject(errorHandler)
                .previewInterfaceOrientation(.portrait)
        }
    }
}

#endif
