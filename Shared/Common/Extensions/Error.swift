//
//  Error.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-16.
//

import Foundation

extension NSError {
    static var badServerResponse: NSError {
        return NSError(domain: "", code: 404, userInfo: nil)
    }
    
    static var authRequired: NSError {
        return NSError(domain: "", code: 401, userInfo: nil)
    }
}
