//
//  NetworkError.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

public enum NetworkError: Error {
    case error(statusCode: Int, data: Data?)
    case notConnected
    case cancelled
    case generic(Error)
    case urlGeneration
}

public protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }
