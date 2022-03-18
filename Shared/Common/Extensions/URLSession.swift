//
//  URLSession.swift
//  ToDoList (iOS)
//
//  Created by Dmytro Brovkin on 2022-03-15.
//

import Foundation

extension URLSession {
    static var `default`: URLSession {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(10)
        config.timeoutIntervalForResource = TimeInterval(10)
        return URLSession(configuration: config, delegate: nil, delegateQueue: OperationQueue.main)
    }
}

extension Int {
    var urlErrorCode: URLError.Code {
        switch self {
        case 401: return URLError.userAuthenticationRequired
        default: return URLError.badServerResponse
        }
    }
}
