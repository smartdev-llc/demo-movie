//
//  Task.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
