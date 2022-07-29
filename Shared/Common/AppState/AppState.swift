//
//  AppState.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Combine
import Foundation

class AppState: ObservableObject {
    @Published var user: User = User(email: "")
    @Published var networkConfig: NetworkConfig = NetworkConfig(token: "")
}
