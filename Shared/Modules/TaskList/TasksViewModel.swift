//
//  TasksViewModel.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-11.
//

import SwiftUI
import Combine

class TasksViewModel: BaseViewModel<[Task]> {
    @Published private(set) var tasks: [Task] = []
    var sortedTasks: [Task] { return tasks.sorted(by: { $0 < $1 }) }
    
    private var api: TaskAPIProtocol
    
    init(api: TaskAPIProtocol) {
        self.api = api
        super.init()
        
        // Binding Api call response to Published variable
        result.assign(to: &$tasks)
    }
    
    func loadData() {
        guard tasks.count == 0 else { return }
        let publisher = api.fetchTasks()
        handle(publisher)
    }
    
    func update(task id: Int, state: Task.State) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else { return }
        var targetTask = tasks[index]
        targetTask.status = state
        
        let publisher = api.update(targetTask)
        handle(publisher) { [weak self] in
            self?.tasks[index] = targetTask
        }
    }
    
    func updateOrReplace(_ task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            tasks.append(task)
            return
        }
        tasks[index] = task
    }
    
    func delete(at indexSet: IndexSet) {
        let indexes = Array(indexSet)
        
        for index in indexes {
            let item = sortedTasks[index]
            
            let publisher = api.delete(item)
            handle(publisher) { [weak self] in
                guard let self = self, let targetIndex = self.tasks.firstIndex(where: { $0.id == item.id }) else { return }
                self.tasks.remove(at: targetIndex)
            }
        }
    }
}
