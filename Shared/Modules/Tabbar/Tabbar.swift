//
//  Tabbar.swift
//  ToDoList (iOS)
//
//  Created by dmytro.brovkin on 2022-09-21.
//

import Foundation
import SwiftUI


struct TabbarView: View {
    
    let factory: TabbarFactory
    
    init(factory: TabbarFactory) {
        self.factory = factory
    }
    
    var body: some View {
        TabView {
            factory.createLoginView()
                .tabItem {
                    Label("Login", systemImage: "list.dash")
                }
            factory.createTasksView()
                .tabItem {
                    Label("Tasks", systemImage: "square.and.pencil")
                }
        }
    }
}
