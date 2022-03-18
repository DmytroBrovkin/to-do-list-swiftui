//
//  Data.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-16.
//

import Foundation

extension Data {
    var dict: [String: Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: [])) as? [String: Any]
    }
    
    var array: [Any]? {
        return (try? JSONSerialization.jsonObject(with: self, options: [])) as? [Any]
    }
}

extension Sequence {
    var data: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: [])
    }
}
