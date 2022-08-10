//
//  ContentView.swift
//  Shared
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI

protocol TasksViewDelegate: AnyObject {
    func view(_ view: TasksView, didSelect task: TaskModel?)
}

struct TasksView: View {    
    @ObservedObject private var errorHandler: TasksErrorHandler
    @ObservedObject private var viewModel: TasksViewModel
    
    private weak var delegate: TasksViewDelegate?
    
    init(viewModel: TasksViewModel, delegate: TasksViewDelegate) {
        self.viewModel = viewModel
        self.errorHandler = TasksErrorHandler(viewModel: viewModel)
        self.delegate = delegate
    }

    var body: some View {
        List {
            ForEach(viewModel.sortedTasks, id: \.id) { task in
                TaskRow(task: task) { id, state in
                    viewModel.update(task: id, state: state)
                }
                // This is needed to cover entire section with tap gesture
                .contentShape(Rectangle())
                .onTapGesture {
                    delegate?.view(self, didSelect: task)
                }
            }.onDelete(perform: viewModel.delete(at:))
        }
        .onReceive(viewModel.error) { error in
            errorHandler.handle(error: error)
        }
        .onAppear(perform: viewModel.loadData)
        .navigationTitle("To do list")
        .toolbar {
            Button("Add") {
                delegate?.view(self, didSelect: nil)
            }
        }
        .navigationBarBackButtonHidden(true)
        .errorHandling($errorHandler.currentAlert)
    }
}

#if DEBUG

struct TasksView_Previews: PreviewProvider {
    @ObservedObject static private var appState = AppState()
    
    static var previews: some View {
        NavigationView {
            TasksView(viewModel: TasksViewModel(api: TaskAPIMock()), delegate: AppRouter())
                .environmentObject(appState)
                .previewInterfaceOrientation(.portrait)
        }
    }
}

#endif
