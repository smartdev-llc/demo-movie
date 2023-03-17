//
//  NetworkService.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

public protocol NetworkService {
    typealias CompletionHandler = (Result<Data?, NetworkError>) -> Void
    
    func request(endpoint: Requestable, completion: @escaping CompletionHandler) -> NetworkCancellable?
}
