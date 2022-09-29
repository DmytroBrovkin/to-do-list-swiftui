//
//  DynatraceEvent.swift
//  ToDoList (iOS)
//
//  Created by dmytro.brovkin on 2022-09-29.
//

import Foundation

class DynatraceEvent {
    private let value: String
    
    init(_ value: String) {
        self.value = value
    }
    
    func leaveWithSuccess() {
        print("DTM event completed successfully - \(value)")
    }
    
    func leaveWithFailure() {
        print("DTM event completed with failure - \(value)")
    }
}
